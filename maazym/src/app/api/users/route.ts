import { NextRequest, NextResponse } from 'next/server';
import { createClient as createSupabaseServiceClient } from '@supabase/supabase-js';
import { createClient } from '@/lib/supabase/server';

function getAdminClient() {
  const key = process.env.SUPABASE_SERVICE_ROLE_KEY;
  if (!key || key === 'your_service_role_key_here') {
    return null;
  }
  return createSupabaseServiceClient(process.env.NEXT_PUBLIC_SUPABASE_URL!, key, {
    auth: { autoRefreshToken: false, persistSession: false },
  });
}

async function checkPermission(requiredRole: 'admin' | 'admin_or_manager') {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) return { allowed: false, role: null as string | null, userId: null as string | null };

  const { data: profile } = await supabase.from('profiles').select('role').eq('id', user.id).single();

  if (!profile) return { allowed: false, role: null, userId: user.id };

  if (requiredRole === 'admin') {
    return { allowed: profile.role === 'admin', role: profile.role, userId: user.id };
  }
  return {
    allowed: ['admin', 'manager'].includes(profile.role),
    role: profile.role,
    userId: user.id,
  };
}

export async function POST(request: NextRequest) {
  const body = await request.json();
  const { action } = body;

  const needsAdminClient = ['create', 'delete', 'reset_password', 'list_emails'];

  if (needsAdminClient.includes(action)) {
    const { allowed, role } = await checkPermission('admin_or_manager');
    if (!allowed) {
      return NextResponse.json({ error: 'Unauthorized' }, { status: 403 });
    }

    const adminClient = getAdminClient();
    if (!adminClient) {
      return NextResponse.json(
        {
          error:
            'Service role key not configured. Add SUPABASE_SERVICE_ROLE_KEY to .env.local (found in Supabase Dashboard > Settings > API)',
        },
        { status: 500 }
      );
    }

    switch (action) {
      case 'create': {
        const { email, password, full_name, role: newRole } = body;
        if (!email || !password || !full_name || !newRole) {
          return NextResponse.json({ error: 'All fields are required' }, { status: 400 });
        }

        if (newRole === 'admin' && role !== 'admin') {
          return NextResponse.json({ error: 'Only admins can create admin users' }, { status: 403 });
        }

        const { data, error } = await adminClient.auth.admin.createUser({
          email,
          password,
          email_confirm: true,
          user_metadata: { full_name },
        });

        if (error) return NextResponse.json({ error: error.message }, { status: 400 });

        if (data.user) {
          await new Promise((r) => setTimeout(r, 500));
          await adminClient
            .from('profiles')
            .update({
              full_name,
              role: newRole,
              branch_id: body.branch_id || '00000000-0000-0000-0000-000000000001',
            })
            .eq('id', data.user.id);
        }

        return NextResponse.json({ user: data.user });
      }

      case 'delete': {
        const { user_id } = body;
        if (!user_id) return NextResponse.json({ error: 'Missing user_id' }, { status: 400 });

        const { data: targetProfile } = await adminClient.from('profiles').select('role').eq('id', user_id).single();
        if (targetProfile?.role === 'admin' && role !== 'admin') {
          return NextResponse.json({ error: 'Only admins can delete admin users' }, { status: 403 });
        }

        await adminClient.from('profiles').delete().eq('id', user_id);
        const { error } = await adminClient.auth.admin.deleteUser(user_id);
        if (error) return NextResponse.json({ error: error.message }, { status: 400 });
        return NextResponse.json({ success: true });
      }

      case 'reset_password': {
        const { user_id, new_password } = body;
        if (!user_id || !new_password) return NextResponse.json({ error: 'Missing fields' }, { status: 400 });
        const { data: targetProfile } = await adminClient.from('profiles').select('role').eq('id', user_id).single();
        if (targetProfile?.role === 'admin' && role !== 'admin') {
          return NextResponse.json({ error: 'Only admins can reset an admin password' }, { status: 403 });
        }
        const { error } = await adminClient.auth.admin.updateUserById(user_id, { password: new_password });
        if (error) return NextResponse.json({ error: error.message }, { status: 400 });
        return NextResponse.json({ success: true });
      }

      case 'list_emails': {
        const { data, error } = await adminClient.auth.admin.listUsers({ perPage: 1000 });
        if (error) return NextResponse.json({ error: error.message }, { status: 400 });
        const emailMap: Record<string, string> = {};
        if (role === 'manager') {
          const { data: profs } = await adminClient.from('profiles').select('id, role');
          const adminIds = new Set((profs || []).filter((p: { role: string }) => p.role === 'admin').map((p: { id: string }) => p.id));
          data.users.forEach((u) => {
            if (!adminIds.has(u.id)) emailMap[u.id] = u.email || '';
          });
        } else {
          data.users.forEach((u) => {
            emailMap[u.id] = u.email || '';
          });
        }
        return NextResponse.json({ emailMap });
      }

      default:
        return NextResponse.json({ error: 'Invalid action' }, { status: 400 });
    }
  }

  if (action === 'update_role') {
    const { allowed, role: callerRole } = await checkPermission('admin_or_manager');
    if (!allowed) return NextResponse.json({ error: 'Unauthorized' }, { status: 403 });

    const { user_id, role: newRole } = body;
    if (!user_id || newRole === undefined || newRole === null || newRole === '') {
      return NextResponse.json({ error: 'Missing fields' }, { status: 400 });
    }
    if (newRole === 'admin' && callerRole !== 'admin') {
      return NextResponse.json({ error: 'Only admins can assign admin role' }, { status: 403 });
    }

    const supabase = await createClient();
    if (callerRole === 'manager') {
      const { data: targetProfile } = await supabase.from('profiles').select('role').eq('id', user_id).single();
      if (targetProfile?.role === 'admin') {
        return NextResponse.json({ error: 'Managers cannot change an admin user' }, { status: 403 });
      }
    }

    const { error } = await supabase.from('profiles').update({ role: newRole }).eq('id', user_id);
    if (error) return NextResponse.json({ error: error.message }, { status: 400 });
    return NextResponse.json({ success: true });
  }

  if (action === 'update_branch') {
    const { allowed } = await checkPermission('admin');
    if (!allowed) {
      return NextResponse.json({ error: 'Unauthorized' }, { status: 403 });
    }

    const { user_id, branch_id } = body;
    if (!user_id || branch_id === undefined || branch_id === null || branch_id === '') {
      return NextResponse.json({ error: 'Missing fields' }, { status: 400 });
    }

    const adminClient = getAdminClient();
    if (!adminClient) {
      return NextResponse.json(
        {
          error:
            'Service role key not configured. Add SUPABASE_SERVICE_ROLE_KEY to .env.local (found in Supabase Dashboard > Settings > API)',
        },
        { status: 500 }
      );
    }

    const { error } = await adminClient.from('profiles').update({ branch_id }).eq('id', user_id);
    if (error) return NextResponse.json({ error: error.message }, { status: 400 });
    return NextResponse.json({ success: true });
  }

  return NextResponse.json({ error: 'Invalid action' }, { status: 400 });
}
