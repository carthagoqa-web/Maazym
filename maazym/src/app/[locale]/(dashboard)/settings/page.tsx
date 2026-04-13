'use client';

import { useCallback, useEffect, useMemo, useState } from 'react';
import { useTranslations, useLocale } from 'next-intl';
import { createClient } from '@/lib/supabase/client';
import type {
  Branch,
  Category,
  InventoryCategory,
  PricingConfig,
  Profile,
  RecipeType,
  SiteBranding,
  SiteIntegrations,
  UserRole,
} from '@/types/database';
import {
  canAccessUsersSettings,
  canDeleteInventoryCatalog,
  canManageBranches,
  canViewFinancials,
} from '@/lib/roles';
import { cn } from '@/lib/utils';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { Tabs, TabsContent, TabsList, TabsTrigger } from '@/components/ui/tabs';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { Textarea } from '@/components/ui/textarea';
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from '@/components/ui/table';
import { Badge } from '@/components/ui/badge';
import { Switch } from '@/components/ui/switch';
import { Skeleton } from '@/components/ui/skeleton';
import {
  Dialog,
  DialogContent,
  DialogFooter,
  DialogHeader,
  DialogTitle,
} from '@/components/ui/dialog';
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from '@/components/ui/select';
import { Plus, Trash2, KeyRound, Loader2, Upload, Edit, ImageIcon, MessageSquare, Building2 } from 'lucide-react';
import { toast } from 'sonner';
import Link from 'next/link';
import { SiteLogo } from '@/components/site-logo';
import { SITE_BRANDING_CHANGED } from '@/contexts/site-branding';

const DEFAULT_BRANCH_ID = '00000000-0000-0000-0000-000000000001';

const USER_ROLES: UserRole[] = ['admin', 'manager', 'purchasing_manager', 'chef', 'bartender'];

export default function SettingsPage() {
  const t = useTranslations('settings');
  const tCommon = useTranslations('common');
  const tAuth = useTranslations('auth');
  const locale = useLocale();

  const [loading, setLoading] = useState(true);
  const [branchId, setBranchId] = useState<string>(DEFAULT_BRANCH_ID);
  const [myProfile, setMyProfile] = useState<Profile | null>(null);
  const [authUserId, setAuthUserId] = useState<string | null>(null);
  const [authEmail, setAuthEmail] = useState<string | null>(null);

  const [pricingRow, setPricingRow] = useState<PricingConfig | null>(null);
  const [margin, setMargin] = useState('65');
  const [currency, setCurrency] = useState('QAR');
  const [taxPercent, setTaxPercent] = useState('15');
  const [pricingSaving, setPricingSaving] = useState(false);

  const [profiles, setProfiles] = useState<Profile[]>([]);
  const [profilesLoading, setProfilesLoading] = useState(false);
  const [profileBusyId, setProfileBusyId] = useState<string | null>(null);

  const [recipeCategories, setRecipeCategories] = useState<Category[]>([]);
  const [inventoryCategories, setInventoryCategories] = useState<InventoryCategory[]>([]);
  const [categoriesLoading, setCategoriesLoading] = useState(false);
  const [recipeDialogOpen, setRecipeDialogOpen] = useState(false);
  const [inventoryDialogOpen, setInventoryDialogOpen] = useState(false);
  const [addUserOpen, setAddUserOpen] = useState(false);
  const [addUserForm, setAddUserForm] = useState({
    full_name: '',
    email: '',
    password: '',
    role: 'chef' as UserRole,
    branch_id: DEFAULT_BRANCH_ID,
  });
  const [addUserSubmitting, setAddUserSubmitting] = useState(false);
  const [addUserError, setAddUserError] = useState('');
  const [emailMap, setEmailMap] = useState<Record<string, string>>({});
  const [emailsLoading, setEmailsLoading] = useState(false);
  const [resetUserId, setResetUserId] = useState<string | null>(null);
  const [resetPwd, setResetPwd] = useState('');
  const [resetPwdConfirm, setResetPwdConfirm] = useState('');
  const [resetSubmitting, setResetSubmitting] = useState(false);
  const [deleteUserId, setDeleteUserId] = useState<string | null>(null);
  const [deleteSubmitting, setDeleteSubmitting] = useState(false);
  const [categorySaving, setCategorySaving] = useState(false);

  const [allBranches, setAllBranches] = useState<Branch[]>([]);
  const [branchForm, setBranchForm] = useState({
    name_ar: '',
    name_en: '',
    address: '',
    phone: '',
  });
  const [branchSaving, setBranchSaving] = useState(false);
  const [branchEditOpen, setBranchEditOpen] = useState(false);
  const [branchEditForm, setBranchEditForm] = useState({
    id: '',
    name_ar: '',
    name_en: '',
    address: '',
    phone: '',
  });

  const [telegramToken, setTelegramToken] = useState('');
  const [telegramChatId, setTelegramChatId] = useState('');
  const [telegramTemplate, setTelegramTemplate] = useState('');
  const [integrationsLoading, setIntegrationsLoading] = useState(false);
  const [integrationsSaving, setIntegrationsSaving] = useState(false);
  const [logoUploading, setLogoUploading] = useState(false);
  const [outletNameEn, setOutletNameEn] = useState('Maazym');
  const [outletNameAr, setOutletNameAr] = useState('معزم');
  const [outletSaving, setOutletSaving] = useState(false);

  const [recipeForm, setRecipeForm] = useState({
    id: '' as string | null,
    name_ar: '',
    name_en: '',
    type: 'food' as RecipeType,
    sort_order: '0',
  });

  const [inventoryForm, setInventoryForm] = useState({
    id: '' as string | null,
    name_ar: '',
    name_en: '',
    sort_order: '0',
  });

  const assignableUserRoles = useMemo(
    () =>
      myProfile?.role === 'admin'
        ? USER_ROLES
        : USER_ROLES.filter((r) => r !== 'admin'),
    [myProfile?.role]
  );

  const visibleProfiles = useMemo(() => {
    if (myProfile?.role === 'manager') {
      return profiles.filter((p) => p.role !== 'admin');
    }
    return profiles;
  }, [profiles, myProfile?.role]);

  const activeBranch = useMemo(
    () => allBranches.find((b) => b.id === branchId),
    [allBranches, branchId]
  );

  const mapUserApiError = useCallback(
    (msg: string | undefined) => {
      if (!msg) return tCommon('error');
      if (msg.includes('Service role key not configured')) return t('serviceKeyError');
      if (msg === 'Only admins can create admin users' || msg === 'Only admins can assign admin role') {
        return t('onlyAdminCanCreate');
      }
      return msg;
    },
    [t, tCommon]
  );

  const isRtl = locale === 'ar';

  const loadBranchData = useCallback(
    async (bid: string, opts: { loadProfiles: boolean }) => {
      const supabase = createClient();
      setCategoriesLoading(true);
      if (opts.loadProfiles) setProfilesLoading(true);

      const [pricingRes, catRes, invCatRes] = await Promise.all([
        supabase.from('pricing_config').select('*').eq('branch_id', bid).maybeSingle(),
        supabase.from('categories').select('*').eq('branch_id', bid).order('sort_order', { ascending: true }),
        supabase
          .from('inventory_categories')
          .select('*')
          .eq('branch_id', bid)
          .order('sort_order', { ascending: true }),
      ]);

      const profilesRes = opts.loadProfiles
        ? await supabase.from('profiles').select('*').order('full_name', { ascending: true })
        : null;

      setCategoriesLoading(false);
      if (opts.loadProfiles) setProfilesLoading(false);

      if (pricingRes.error) {
        toast.error(t('pricingLoadError'));
      } else if (pricingRes.data) {
        const row = pricingRes.data as PricingConfig;
        setPricingRow(row);
        setMargin(String(row.default_margin_percent));
        setCurrency(row.currency);
        setTaxPercent(String(row.tax_percent));
      } else {
        setPricingRow(null);
        setMargin('65');
        setCurrency('QAR');
        setTaxPercent('15');
      }

      if (catRes.error) {
        toast.error(tCommon('error'));
        setRecipeCategories([]);
      } else {
        setRecipeCategories((catRes.data as Category[]) || []);
      }

      if (invCatRes.error) {
        toast.error(tCommon('error'));
        setInventoryCategories([]);
      } else {
        setInventoryCategories((invCatRes.data as InventoryCategory[]) || []);
      }

      if (opts.loadProfiles && profilesRes) {
        if (profilesRes.error) {
          toast.error(tCommon('error'));
          setProfiles([]);
        } else if (profilesRes.data) {
          setProfiles(profilesRes.data as Profile[]);
        }
      }
    },
    [t, tCommon]
  );

  const bootstrap = useCallback(async () => {
    const supabase = createClient();
    const {
      data: { user },
    } = await supabase.auth.getUser();

    setAuthUserId(user?.id ?? null);
    setAuthEmail(user?.email ?? null);

    if (!user) {
      setLoading(false);
      return;
    }

    const { data: profile, error } = await supabase.from('profiles').select('*').eq('id', user.id).maybeSingle();

    if (error || !profile) {
      toast.error(tCommon('error'));
      setLoading(false);
      return;
    }

    const p = profile as Profile;
    setMyProfile(p);
    const bid = p.branch_id ?? DEFAULT_BRANCH_ID;
    setBranchId(bid);

    if (p.branch_id == null) {
      toast.info(t('noBranchHint'));
    }

    if (p.role === 'admin' || p.role === 'manager') {
      const { data: brList } = await supabase.from('branches').select('*').order('name_en', { ascending: true });
      setAllBranches((brList as Branch[]) || []);
      setEmailsLoading(true);
      await Promise.all([
        loadBranchData(bid, { loadProfiles: true }),
        (async () => {
          try {
            const res = await fetch('/api/users', {
              method: 'POST',
              headers: { 'Content-Type': 'application/json' },
              body: JSON.stringify({ action: 'list_emails' }),
            });
            const json = (await res.json()) as { error?: string; emailMap?: Record<string, string> };
            if (!res.ok) {
              toast.error(mapUserApiError(typeof json.error === 'string' ? json.error : undefined));
              setEmailMap({});
            } else {
              setEmailMap(json.emailMap ?? {});
            }
          } catch {
            toast.error(tCommon('error'));
            setEmailMap({});
          } finally {
            setEmailsLoading(false);
          }
        })(),
      ]);
    } else {
      await loadBranchData(bid, { loadProfiles: false });
    }
    setLoading(false);
  }, [loadBranchData, mapUserApiError, t, tCommon]);

  useEffect(() => {
    bootstrap();
  }, [bootstrap]);

  useEffect(() => {
    if (loading || myProfile?.role !== 'admin') return;
    let cancelled = false;
    (async () => {
      setIntegrationsLoading(true);
      const supabase = createClient();
      const [brandRes, intRes] = await Promise.all([
        supabase.from('site_branding').select('outlet_name_en, outlet_name_ar').eq('id', 1).maybeSingle(),
        supabase.from('site_integrations').select('*').eq('id', 1).maybeSingle(),
      ]);
      if (cancelled) return;
      setIntegrationsLoading(false);
      if (brandRes.data) {
        const b = brandRes.data as Pick<SiteBranding, 'outlet_name_en' | 'outlet_name_ar'>;
        setOutletNameEn(b.outlet_name_en?.trim() || 'Maazym');
        setOutletNameAr(b.outlet_name_ar?.trim() || 'معزم');
      }
      if (intRes.error || !intRes.data) return;
      const row = intRes.data as SiteIntegrations;
      setTelegramToken(row.telegram_bot_token ?? '');
      setTelegramChatId(row.telegram_chat_id ?? '');
      setTelegramTemplate(row.telegram_message_template ?? '');
    })();
    return () => {
      cancelled = true;
    };
  }, [loading, myProfile?.role]);

  const roleBadgeClass = (role: UserRole) =>
    cn(
      'capitalize',
      role === 'admin' && 'bg-violet-100 text-violet-900 dark:bg-violet-950 dark:text-violet-200',
      role === 'manager' && 'bg-blue-100 text-blue-900 dark:bg-blue-950 dark:text-blue-200',
      role === 'purchasing_manager' &&
        'bg-cyan-100 text-cyan-900 dark:bg-cyan-950 dark:text-cyan-200',
      role === 'chef' && 'bg-amber-100 text-amber-900 dark:bg-amber-950 dark:text-amber-200',
      role === 'bartender' && 'bg-emerald-100 text-emerald-900 dark:bg-emerald-950 dark:text-emerald-200'
    );

  const displayEmailForProfile = (profileId: string) => {
    const mapped = emailMap[profileId];
    if (mapped) return mapped;
    if (authUserId && profileId === authUserId && authEmail) return authEmail;
    return t('emailUnavailable');
  };

  const usersTableLoading = profilesLoading || emailsLoading;

  async function refreshEmailMap() {
    try {
      const res = await fetch('/api/users', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ action: 'list_emails' }),
      });
      const json = (await res.json()) as { error?: string; emailMap?: Record<string, string> };
      if (res.ok && json.emailMap) {
        setEmailMap(json.emailMap);
      }
    } catch {
      /* ignore background refresh */
    }
  }

  async function submitCreateUser() {
    setAddUserError('');
    const full_name = addUserForm.full_name.trim();
    const email = addUserForm.email.trim();
    const password = addUserForm.password;
    if (!full_name || !email || !password) {
      setAddUserError(tCommon('error'));
      return;
    }
    if (!addUserForm.role) {
      setAddUserError(tCommon('error'));
      return;
    }
    setAddUserSubmitting(true);
    try {
      const res = await fetch('/api/users', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          action: 'create',
          email,
          password,
          full_name,
          role: addUserForm.role,
          branch_id: myProfile?.role === 'admin' ? addUserForm.branch_id : branchId,
        }),
      });
      const json = (await res.json()) as { error?: string; user?: { id: string; email?: string } };
      if (!res.ok) {
        const mapped = mapUserApiError(typeof json.error === 'string' ? json.error : undefined);
        setAddUserError(mapped);
        toast.error(mapped);
        return;
      }
      toast.success(t('userCreated'));
      setAddUserError('');
      setAddUserOpen(false);
      setAddUserForm({ full_name: '', email: '', password: '', role: 'chef', branch_id: DEFAULT_BRANCH_ID });
      await loadBranchData(branchId, { loadProfiles: true });
      if (json.user?.id) {
        setEmailMap((prev) => ({
          ...prev,
          [json.user!.id]: json.user!.email ?? email,
        }));
      }
      await refreshEmailMap();
    } catch {
      const fallback = tCommon('error');
      setAddUserError(fallback);
      toast.error(fallback);
    } finally {
      setAddUserSubmitting(false);
    }
  }

  async function submitResetPassword() {
    if (!resetUserId) return;
    if (resetPwd !== resetPwdConfirm) {
      toast.error(t('passwordMismatch'));
      return;
    }
    if (!resetPwd) {
      toast.error(tCommon('error'));
      return;
    }
    setResetSubmitting(true);
    try {
      const res = await fetch('/api/users', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          action: 'reset_password',
          user_id: resetUserId,
          new_password: resetPwd,
        }),
      });
      const json = (await res.json()) as { error?: string };
      if (!res.ok) {
        toast.error(mapUserApiError(typeof json.error === 'string' ? json.error : undefined));
        return;
      }
      toast.success(t('passwordResetSuccess'));
      setResetUserId(null);
      setResetPwd('');
      setResetPwdConfirm('');
    } catch {
      toast.error(tCommon('error'));
    } finally {
      setResetSubmitting(false);
    }
  }

  async function submitDeleteUser() {
    if (!deleteUserId) return;
    if (deleteUserId === authUserId) {
      toast.error(t('cannotDeleteSelf'));
      return;
    }
    setDeleteSubmitting(true);
    try {
      const res = await fetch('/api/users', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ action: 'delete', user_id: deleteUserId }),
      });
      const json = (await res.json()) as { error?: string };
      if (!res.ok) {
        toast.error(mapUserApiError(typeof json.error === 'string' ? json.error : undefined));
        return;
      }
      setProfiles((prev) => prev.filter((p) => p.id !== deleteUserId));
      setEmailMap((prev) => {
        const next = { ...prev };
        delete next[deleteUserId];
        return next;
      });
      toast.success(tCommon('deleted'));
      setDeleteUserId(null);
    } catch {
      toast.error(tCommon('error'));
    } finally {
      setDeleteSubmitting(false);
    }
  }

  function openResetPasswordDialog(userId: string) {
    setResetUserId(userId);
    setResetPwd('');
    setResetPwdConfirm('');
  }

  function openDeleteDialog(userId: string) {
    if (userId === authUserId) {
      toast.error(t('cannotDeleteSelf'));
      return;
    }
    setDeleteUserId(userId);
  }

  async function savePricing() {
    const supabase = createClient();
    setPricingSaving(true);
    const taxNum = Number.parseFloat(taxPercent);
    if (Number.isNaN(taxNum)) {
      toast.error(tCommon('error'));
      setPricingSaving(false);
      return;
    }

    const isAdminUser = myProfile?.role === 'admin';
    let marginNum: number;
    if (isAdminUser) {
      marginNum = Number.parseFloat(margin);
      if (Number.isNaN(marginNum) || marginNum < 0) {
        toast.error(tCommon('error'));
        setPricingSaving(false);
        return;
      }
    } else {
      marginNum = Number(pricingRow?.default_margin_percent ?? 65);
    }

    const payload = {
      default_margin_percent: marginNum,
      currency: currency.trim() || 'QAR',
      tax_percent: taxNum,
      branch_id: branchId,
    };

    const { data, error } = pricingRow?.id
      ? await supabase
          .from('pricing_config')
          .update(
            isAdminUser
              ? {
                  default_margin_percent: payload.default_margin_percent,
                  currency: payload.currency,
                  tax_percent: payload.tax_percent,
                }
              : {
                  currency: payload.currency,
                  tax_percent: payload.tax_percent,
                }
          )
          .eq('id', pricingRow.id)
          .select()
          .single()
      : await supabase.from('pricing_config').insert(payload).select().single();

    setPricingSaving(false);
    if (error) {
      toast.error(t('pricingSaveError'));
      return;
    }
    setPricingRow(data as PricingConfig);
    toast.success(tCommon('updated'));
  }

  function branchLabel(b: Branch) {
    return locale === 'ar' ? b.name_ar : b.name_en;
  }

  async function saveOutletBranding() {
    const en = outletNameEn.trim() || 'Maazym';
    const ar = outletNameAr.trim() || 'معزم';
    setOutletSaving(true);
    const supabase = createClient();
    const { error } = await supabase
      .from('site_branding')
      .update({
        outlet_name_en: en,
        outlet_name_ar: ar,
        updated_at: new Date().toISOString(),
      })
      .eq('id', 1);
    setOutletSaving(false);
    if (error) {
      toast.error(error.message);
      return;
    }
    toast.success(tCommon('updated'));
    window.dispatchEvent(new Event(SITE_BRANDING_CHANGED));
  }

  async function saveTelegramIntegration() {
    setIntegrationsSaving(true);
    const supabase = createClient();
    const { error } = await supabase
      .from('site_integrations')
      .update({
        telegram_bot_token: telegramToken.trim() || null,
        telegram_chat_id: telegramChatId.trim() || null,
        telegram_message_template: telegramTemplate,
        updated_at: new Date().toISOString(),
      })
      .eq('id', 1);
    setIntegrationsSaving(false);
    if (error) {
      toast.error(error.message);
      return;
    }
    toast.success(tCommon('updated'));
  }

  async function uploadSiteLogo(file: File) {
    const extRaw = file.name.split('.').pop()?.toLowerCase() ?? '';
    const allowed = ['png', 'jpg', 'jpeg', 'webp', 'gif', 'svg'];
    if (!allowed.includes(extRaw)) {
      toast.error(t('logoInvalidType'));
      return;
    }
    const ext = extRaw === 'jpg' ? 'jpeg' : extRaw;
    const path = `branding/logo.${ext}`;
    setLogoUploading(true);
    const supabase = createClient();
    const { error: upErr } = await supabase.storage.from('site-assets').upload(path, file, {
      upsert: true,
      contentType: file.type || `image/${ext}`,
    });
    if (upErr) {
      setLogoUploading(false);
      toast.error(upErr.message);
      return;
    }
    const { error: dbErr } = await supabase
      .from('site_branding')
      .update({ logo_path: path, updated_at: new Date().toISOString() })
      .eq('id', 1);
    setLogoUploading(false);
    if (dbErr) {
      toast.error(dbErr.message);
      return;
    }
    toast.success(t('logoUpdated'));
    window.dispatchEvent(new Event(SITE_BRANDING_CHANGED));
  }

  async function removeSiteLogo() {
    const supabase = createClient();
    const { data: row } = await supabase.from('site_branding').select('logo_path').eq('id', 1).maybeSingle();
    const p = row?.logo_path;
    if (p) {
      await supabase.storage.from('site-assets').remove([p]);
    }
    const { error } = await supabase
      .from('site_branding')
      .update({ logo_path: null, updated_at: new Date().toISOString() })
      .eq('id', 1);
    if (error) {
      toast.error(error.message);
      return;
    }
    toast.success(tCommon('updated'));
    window.dispatchEvent(new Event(SITE_BRANDING_CHANGED));
  }

  async function updateProfileBranch(profileId: string, newBranchId: string) {
    if (myProfile?.role !== 'admin') return;
    setProfileBusyId(profileId);
    try {
      const res = await fetch('/api/users', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ action: 'update_branch', user_id: profileId, branch_id: newBranchId }),
      });
      const json = (await res.json()) as { error?: string };
      if (!res.ok) {
        toast.error(mapUserApiError(typeof json.error === 'string' ? json.error : undefined));
        return;
      }
      setProfiles((prev) =>
        prev.map((p) => (p.id === profileId ? { ...p, branch_id: newBranchId } : p))
      );
      toast.success(tCommon('updated'));
    } catch {
      toast.error(t('profileUpdateError'));
    } finally {
      setProfileBusyId(null);
    }
  }

  async function updateProfileRole(profileId: string, role: UserRole) {
    setProfileBusyId(profileId);
    try {
      const res = await fetch('/api/users', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ action: 'update_role', user_id: profileId, role }),
      });
      const json = (await res.json()) as { error?: string };
      if (!res.ok) {
        toast.error(mapUserApiError(typeof json.error === 'string' ? json.error : undefined));
        return;
      }
      setProfiles((prev) => prev.map((p) => (p.id === profileId ? { ...p, role } : p)));
      toast.success(tCommon('updated'));
    } catch {
      toast.error(t('profileUpdateError'));
    } finally {
      setProfileBusyId(null);
    }
  }

  async function updateProfileActive(profileId: string, is_active: boolean) {
    const supabase = createClient();
    setProfileBusyId(profileId);
    const { error } = await supabase.from('profiles').update({ is_active }).eq('id', profileId);
    setProfileBusyId(null);
    if (error) {
      toast.error(t('profileUpdateError'));
      return;
    }
    setProfiles((prev) => prev.map((p) => (p.id === profileId ? { ...p, is_active } : p)));
    toast.success(tCommon('updated'));
  }

  function openRecipeDialog(row: Category | null) {
    if (row) {
      setRecipeForm({
        id: row.id,
        name_ar: row.name_ar,
        name_en: row.name_en,
        type: row.type,
        sort_order: String(row.sort_order),
      });
    } else {
      setRecipeForm({
        id: null,
        name_ar: '',
        name_en: '',
        type: 'food',
        sort_order: String((recipeCategories[recipeCategories.length - 1]?.sort_order ?? 0) + 1),
      });
    }
    setRecipeDialogOpen(true);
  }

  function openInventoryDialog(row: InventoryCategory | null) {
    if (row) {
      setInventoryForm({
        id: row.id,
        name_ar: row.name_ar,
        name_en: row.name_en,
        sort_order: String(row.sort_order),
      });
    } else {
      setInventoryForm({
        id: null,
        name_ar: '',
        name_en: '',
        sort_order: String((inventoryCategories[inventoryCategories.length - 1]?.sort_order ?? 0) + 1),
      });
    }
    setInventoryDialogOpen(true);
  }

  async function saveRecipeCategory() {
    const supabase = createClient();
    const sort = Number.parseInt(recipeForm.sort_order, 10);
    if (!recipeForm.name_ar.trim() || !recipeForm.name_en.trim() || Number.isNaN(sort)) {
      toast.error(tCommon('error'));
      return;
    }
    setCategorySaving(true);
    const base = {
      name_ar: recipeForm.name_ar.trim(),
      name_en: recipeForm.name_en.trim(),
      type: recipeForm.type,
      sort_order: sort,
      branch_id: branchId,
    };
    const { error } = recipeForm.id
      ? await supabase.from('categories').update(base).eq('id', recipeForm.id)
      : await supabase.from('categories').insert({ ...base, is_active: true });
    setCategorySaving(false);
    if (error) {
      toast.error(t('categorySaveError'));
      return;
    }
    setRecipeDialogOpen(false);
    toast.success(tCommon('updated'));
    await loadBranchData(branchId, { loadProfiles: false });
  }

  async function saveInventoryCategory() {
    const supabase = createClient();
    const sort = Number.parseInt(inventoryForm.sort_order, 10);
    if (!inventoryForm.name_ar.trim() || !inventoryForm.name_en.trim() || Number.isNaN(sort)) {
      toast.error(tCommon('error'));
      return;
    }
    setCategorySaving(true);
    const base = {
      name_ar: inventoryForm.name_ar.trim(),
      name_en: inventoryForm.name_en.trim(),
      sort_order: sort,
      branch_id: branchId,
    };
    const { error } = inventoryForm.id
      ? await supabase.from('inventory_categories').update(base).eq('id', inventoryForm.id)
      : await supabase.from('inventory_categories').insert({ ...base, is_active: true });
    setCategorySaving(false);
    if (error) {
      toast.error(t('categorySaveError'));
      return;
    }
    setInventoryDialogOpen(false);
    toast.success(tCommon('updated'));
    await loadBranchData(branchId, { loadProfiles: false });
  }

  async function deleteRecipeCategory(id: string) {
    if (!confirm(t('deleteRecipeCategoryConfirm'))) return;
    const supabase = createClient();
    const { error } = await supabase.from('categories').delete().eq('id', id);
    if (error) {
      toast.error(t('categoryDeleteError'));
      return;
    }
    toast.success(tCommon('deleted'));
    await loadBranchData(branchId, { loadProfiles: false });
  }

  async function submitAddBranch() {
    const name_ar = branchForm.name_ar.trim();
    const name_en = branchForm.name_en.trim();
    if (!name_ar || !name_en) {
      toast.error(tCommon('error'));
      return;
    }
    setBranchSaving(true);
    try {
      const supabase = createClient();
      const { error } = await supabase.from('branches').insert({
        name_ar,
        name_en,
        address: branchForm.address.trim() || null,
        phone: branchForm.phone.trim() || null,
      });
      if (error) throw error;
      toast.success(tCommon('created'));
      setBranchForm({ name_ar: '', name_en: '', address: '', phone: '' });
      const { data: brList } = await supabase.from('branches').select('*').order('name_en', { ascending: true });
      setAllBranches((brList as Branch[]) || []);
    } catch (e: unknown) {
      toast.error(e instanceof Error ? e.message : tCommon('error'));
    } finally {
      setBranchSaving(false);
    }
  }

  function openEditBranch(b: Branch) {
    setBranchEditForm({
      id: b.id,
      name_ar: b.name_ar,
      name_en: b.name_en,
      address: b.address ?? '',
      phone: b.phone ?? '',
    });
    setBranchEditOpen(true);
  }

  async function submitUpdateBranch() {
    const name_ar = branchEditForm.name_ar.trim();
    const name_en = branchEditForm.name_en.trim();
    if (!branchEditForm.id || !name_ar || !name_en) {
      toast.error(tCommon('error'));
      return;
    }
    setBranchSaving(true);
    try {
      const supabase = createClient();
      const { error } = await supabase
        .from('branches')
        .update({
          name_ar,
          name_en,
          address: branchEditForm.address.trim() || null,
          phone: branchEditForm.phone.trim() || null,
        })
        .eq('id', branchEditForm.id);
      if (error) throw error;
      toast.success(tCommon('updated'));
      setBranchEditOpen(false);
      const { data: brList } = await supabase.from('branches').select('*').order('name_en', { ascending: true });
      setAllBranches((brList as Branch[]) || []);
    } catch (e: unknown) {
      toast.error(e instanceof Error ? e.message : tCommon('error'));
    } finally {
      setBranchSaving(false);
    }
  }

  async function deleteBranch(id: string) {
    if (id === DEFAULT_BRANCH_ID) {
      toast.error(t('cannotDeleteDefaultBranch'));
      return;
    }
    if (!confirm(t('deleteBranchConfirm'))) return;
    const supabase = createClient();
    const { error } = await supabase.from('branches').delete().eq('id', id);
    if (error) {
      toast.error(t('branchDeleteError'));
      return;
    }
    toast.success(tCommon('deleted'));
    const { data: brList } = await supabase.from('branches').select('*').order('name_en', { ascending: true });
    setAllBranches((brList as Branch[]) || []);
    if (branchId === id) {
      setBranchId(DEFAULT_BRANCH_ID);
      await loadBranchData(DEFAULT_BRANCH_ID, { loadProfiles: false });
    }
  }

  async function deleteInventoryCategory(id: string) {
    if (!canDeleteInventoryCatalog(myProfile?.role)) {
      toast.error(t('onlyAdminCanDeleteInventoryCategory'));
      return;
    }
    if (!confirm(t('deleteInventoryCategoryConfirm'))) return;
    const supabase = createClient();
    const { error } = await supabase.from('inventory_categories').delete().eq('id', id);
    if (error) {
      toast.error(t('categoryDeleteError'));
      return;
    }
    toast.success(tCommon('deleted'));
    await loadBranchData(branchId, { loadProfiles: false });
  }

  if (loading) {
    return (
      <div className="space-y-6">
        <Skeleton className="h-8 w-56" />
        <Skeleton className="h-12 w-full max-w-md" />
        <Skeleton className="h-96" />
      </div>
    );
  }

  return (
    <div className="space-y-6">
           <div className="flex flex-col gap-4 sm:flex-row sm:items-center sm:justify-between">
        <h1 className="text-2xl font-bold">{t('title')}</h1>
        <div className="flex flex-wrap items-center gap-2">
          {canViewFinancials(myProfile?.role) ? (
            <Link href={`/${locale}/settings/bulk-upload`}>
              <Button variant="outline" size="sm">
                <Upload className="h-4 w-4 me-2" />
                {t('bulkUploadLink')}
              </Button>
            </Link>
          ) : null}
        </div>
      </div>

      {canManageBranches(myProfile?.role) && allBranches.length > 0 ? (
        <Card>
          <CardHeader className="pb-2">
            <CardTitle className="text-base">{t('activeBranch')}</CardTitle>
            <CardDescription>{t('branchContextHint')}</CardDescription>
          </CardHeader>
          <CardContent className="max-w-md">
            <Select
              value={branchId}
              onValueChange={(v) => {
                const next = v ?? DEFAULT_BRANCH_ID;
                setBranchId(next);
                void loadBranchData(next, { loadProfiles: false });
              }}
            >
              <SelectTrigger className="w-full max-w-md">
                <SelectValue placeholder={t('activeBranch')}>
                  {activeBranch ? branchLabel(activeBranch) : branchId}
                </SelectValue>
              </SelectTrigger>
              <SelectContent>
                {allBranches.map((b) => (
                  <SelectItem key={b.id} value={b.id} label={locale === 'ar' ? b.name_ar : b.name_en}>
                    {locale === 'ar' ? b.name_ar : b.name_en}
                  </SelectItem>
                ))}
              </SelectContent>
            </Select>
          </CardContent>
        </Card>
      ) : null}

      <Tabs dir={isRtl ? 'rtl' : 'ltr'} defaultValue="general" className="space-y-6">
        <TabsList className={cn('flex flex-wrap h-auto gap-1', isRtl && 'flex-row-reverse')}>
          <TabsTrigger value="general">{t('general')}</TabsTrigger>
          {canAccessUsersSettings(myProfile?.role) ? (
            <TabsTrigger value="users">{t('users')}</TabsTrigger>
          ) : null}
          {canManageBranches(myProfile?.role) ? (
            <TabsTrigger value="branches">{t('branchesManage')}</TabsTrigger>
          ) : null}
          {myProfile?.role === 'admin' ? (
            <TabsTrigger value="integrations">{t('integrations')}</TabsTrigger>
          ) : null}
          <TabsTrigger value="categories">{t('categoriesTitle')}</TabsTrigger>
        </TabsList>

        <TabsContent value="general" className="space-y-4">
          {canViewFinancials(myProfile?.role) ? (
            <Card>
              <CardHeader>
                <CardTitle>{t('general')}</CardTitle>
                <CardDescription>{t('generalHint')}</CardDescription>
              </CardHeader>
              <CardContent className="space-y-4 max-w-lg">
                {myProfile?.role === 'admin' ? (
                  <div className="space-y-2">
                    <Label htmlFor="margin">{t('defaultMargin')}</Label>
                    <Input
                      id="margin"
                      type="number"
                      step="0.01"
                      min={0}
                      value={margin}
                      onChange={(e) => setMargin(e.target.value)}
                    />
                  </div>
                ) : (
                  <p className="text-sm text-muted-foreground">{t('defaultMarginAdminOnly')}</p>
                )}
                <div className="space-y-2">
                  <Label htmlFor="currency">{t('currency')}</Label>
                  <Input id="currency" value={currency} onChange={(e) => setCurrency(e.target.value)} />
                </div>
                <div className="space-y-2">
                  <Label htmlFor="tax">{t('taxPercent')}</Label>
                  <Input
                    id="tax"
                    type="number"
                    step="0.01"
                    min={0}
                    value={taxPercent}
                    onChange={(e) => setTaxPercent(e.target.value)}
                  />
                </div>
                <Button onClick={savePricing} disabled={pricingSaving}>
                  {pricingSaving ? tCommon('loading') : tCommon('save')}
                </Button>
              </CardContent>
            </Card>
          ) : (
            <Card>
              <CardHeader>
                <CardTitle>{t('general')}</CardTitle>
                <CardDescription>{t('pricingRestrictedHint')}</CardDescription>
              </CardHeader>
            </Card>
          )}
        </TabsContent>

        {canAccessUsersSettings(myProfile?.role) ? (
          <TabsContent value="users" className="space-y-4">
            <Card>
              <CardHeader className="flex flex-col gap-2 sm:flex-row sm:items-center sm:justify-between">
                <div>
                  <CardTitle>{t('users')}</CardTitle>
                </div>
                <Button
                  variant="outline"
                  size="sm"
                  onClick={() => {
                    setAddUserError('');
                    setAddUserForm((f) => ({
                      ...f,
                      role: assignableUserRoles.includes(f.role) ? f.role : 'chef',
                      branch_id: branchId,
                    }));
                    setAddUserOpen(true);
                  }}
                >
                  <Plus className="h-4 w-4 me-2" />
                  {t('addUser')}
                </Button>
              </CardHeader>
              <CardContent>
                {usersTableLoading ? (
                  <Skeleton className="h-48 w-full" />
                ) : (
                  <div className="rounded-md border overflow-x-auto">
                    <Table>
                      <TableHeader>
                        <TableRow>
                          <TableHead>{t('fullName')}</TableHead>
                          <TableHead>{tAuth('email')}</TableHead>
                          {myProfile?.role === 'admin' ? <TableHead>{t('userBranch')}</TableHead> : null}
                          <TableHead>{t('role')}</TableHead>
                          <TableHead>{tCommon('active')}</TableHead>
                          <TableHead className="min-w-[280px]">{tCommon('actions')}</TableHead>
                        </TableRow>
                      </TableHeader>
                      <TableBody>
                        {visibleProfiles.length === 0 ? (
                          <TableRow>
                            <TableCell
                              colSpan={myProfile?.role === 'admin' ? 6 : 5}
                              className="text-center text-muted-foreground"
                            >
                              {tCommon('noResults')}
                            </TableCell>
                          </TableRow>
                        ) : (
                          visibleProfiles.map((p) => (
                            <TableRow key={p.id}>
                              <TableCell className="font-medium">{p.full_name}</TableCell>
                              <TableCell className="text-muted-foreground whitespace-nowrap">
                                {displayEmailForProfile(p.id)}
                              </TableCell>
                              {myProfile?.role === 'admin' ? (
                                <TableCell>
                                  <Select
                                    value={p.branch_id ?? DEFAULT_BRANCH_ID}
                                    disabled={profileBusyId === p.id || allBranches.length === 0}
                                    onValueChange={(v) =>
                                      updateProfileBranch(p.id, v ?? DEFAULT_BRANCH_ID)
                                    }
                                  >
                                    <SelectTrigger className="w-[min(220px,50vw)]">
                                      <SelectValue placeholder={t('userBranch')}>
                                        {(() => {
                                          const pb = allBranches.find(
                                            (b) => b.id === (p.branch_id ?? DEFAULT_BRANCH_ID)
                                          );
                                          return pb ? branchLabel(pb) : (p.branch_id ?? DEFAULT_BRANCH_ID);
                                        })()}
                                      </SelectValue>
                                    </SelectTrigger>
                                    <SelectContent>
                                      {allBranches.map((b) => (
                                        <SelectItem key={b.id} value={b.id} label={branchLabel(b)}>
                                          {branchLabel(b)}
                                        </SelectItem>
                                      ))}
                                    </SelectContent>
                                  </Select>
                                </TableCell>
                              ) : null}
                              <TableCell>
                                <Badge className={roleBadgeClass(p.role)}>{t(`roles.${p.role}`)}</Badge>
                              </TableCell>
                              <TableCell>
                                <Switch
                                  checked={p.is_active}
                                  disabled={profileBusyId === p.id}
                                  onCheckedChange={(v) => updateProfileActive(p.id, Boolean(v))}
                                />
                              </TableCell>
                              <TableCell>
                                <div className="flex flex-col gap-2 sm:flex-row sm:flex-wrap sm:items-center">
                                  <Select
                                    value={p.role}
                                    disabled={profileBusyId === p.id}
                                    onValueChange={(v) => updateProfileRole(p.id, v as UserRole)}
                                  >
                                    <SelectTrigger className="w-full sm:w-[160px]">
                                      <SelectValue placeholder={t('role')} />
                                    </SelectTrigger>
                                    <SelectContent>
                                      {assignableUserRoles.map((r) => (
                                        <SelectItem key={r} value={r}>
                                          {t(`roles.${r}`)}
                                        </SelectItem>
                                      ))}
                                    </SelectContent>
                                  </Select>
                                  <Button
                                    type="button"
                                    variant="outline"
                                    size="sm"
                                    className="shrink-0"
                                    onClick={() => openResetPasswordDialog(p.id)}
                                  >
                                    <KeyRound className="h-4 w-4 me-1" />
                                    {t('resetPassword')}
                                  </Button>
                                  <Button
                                    type="button"
                                    variant="ghost"
                                    size="sm"
                                    className="shrink-0 text-destructive hover:text-destructive"
                                    disabled={p.id === authUserId}
                                    onClick={() => openDeleteDialog(p.id)}
                                  >
                                    <Trash2 className="h-4 w-4 me-1" />
                                    {t('deleteUser')}
                                  </Button>
                                </div>
                              </TableCell>
                            </TableRow>
                          ))
                        )}
                      </TableBody>
                    </Table>
                  </div>
                )}
              </CardContent>
            </Card>

            <Dialog
              open={addUserOpen}
              onOpenChange={(open) => {
                setAddUserOpen(open);
                setAddUserError('');
                if (!open) {
                  setAddUserForm({ full_name: '', email: '', password: '', role: 'chef', branch_id: DEFAULT_BRANCH_ID });
                }
              }}
            >
              <DialogContent className="sm:max-w-md" showCloseButton>
                <DialogHeader>
                  <DialogTitle>{t('addUser')}</DialogTitle>
                </DialogHeader>
                <div className="space-y-3">
                  {addUserError ? (
                    <p className="text-sm text-destructive" role="alert">
                      {addUserError}
                    </p>
                  ) : null}
                  <div className="space-y-2">
                    <Label htmlFor="add-user-full-name">{t('fullName')}</Label>
                    <Input
                      id="add-user-full-name"
                      value={addUserForm.full_name}
                      onChange={(e) => {
                        setAddUserError('');
                        setAddUserForm((f) => ({ ...f, full_name: e.target.value }));
                      }}
                    />
                  </div>
                  <div className="space-y-2">
                    <Label htmlFor="add-user-email">{tAuth('email')}</Label>
                    <Input
                      id="add-user-email"
                      type="email"
                      autoComplete="off"
                      value={addUserForm.email}
                      onChange={(e) => {
                        setAddUserError('');
                        setAddUserForm((f) => ({ ...f, email: e.target.value }));
                      }}
                    />
                  </div>
                  <div className="space-y-2">
                    <Label htmlFor="add-user-password">{tAuth('password')}</Label>
                    <Input
                      id="add-user-password"
                      type="password"
                      autoComplete="new-password"
                      value={addUserForm.password}
                      onChange={(e) => {
                        setAddUserError('');
                        setAddUserForm((f) => ({ ...f, password: e.target.value }));
                      }}
                    />
                  </div>
                  <div className="space-y-2">
                    <Label>{t('role')}</Label>
                    <Select
                      value={addUserForm.role}
                      onValueChange={(v) => {
                        setAddUserError('');
                        setAddUserForm((f) => ({ ...f, role: v as UserRole }));
                      }}
                    >
                      <SelectTrigger>
                        <SelectValue />
                      </SelectTrigger>
                      <SelectContent>
                        {assignableUserRoles.map((r) => (
                          <SelectItem key={r} value={r}>
                            {t(`roles.${r}`)}
                          </SelectItem>
                        ))}
                      </SelectContent>
                    </Select>
                  </div>
                  {myProfile?.role === 'admin' && allBranches.length > 0 ? (
                    <div className="space-y-2">
                      <Label>{t('userBranch')}</Label>
                      <Select
                        value={addUserForm.branch_id}
                        onValueChange={(v) => {
                          setAddUserError('');
                          setAddUserForm((f) => ({ ...f, branch_id: v ?? DEFAULT_BRANCH_ID }));
                        }}
                      >
                        <SelectTrigger>
                          <SelectValue placeholder={t('userBranch')}>
                            {(() => {
                              const pb = allBranches.find((b) => b.id === addUserForm.branch_id);
                              return pb ? branchLabel(pb) : addUserForm.branch_id;
                            })()}
                          </SelectValue>
                        </SelectTrigger>
                        <SelectContent>
                          {allBranches.map((b) => (
                            <SelectItem key={b.id} value={b.id} label={branchLabel(b)}>
                              {branchLabel(b)}
                            </SelectItem>
                          ))}
                        </SelectContent>
                      </Select>
                    </div>
                  ) : null}
                </div>
                <DialogFooter>
                  <Button variant="outline" onClick={() => setAddUserOpen(false)} disabled={addUserSubmitting}>
                    {tCommon('cancel')}
                  </Button>
                  <Button onClick={() => void submitCreateUser()} disabled={addUserSubmitting}>
                    {addUserSubmitting ? (
                      <>
                        <Loader2 className="h-4 w-4 me-2 animate-spin" />
                        {tCommon('loading')}
                      </>
                    ) : (
                      t('addUser')
                    )}
                  </Button>
                </DialogFooter>
              </DialogContent>
            </Dialog>

            <Dialog
              open={resetUserId !== null}
              onOpenChange={(open) => {
                if (!open) {
                  setResetUserId(null);
                  setResetPwd('');
                  setResetPwdConfirm('');
                }
              }}
            >
              <DialogContent className="sm:max-w-md" showCloseButton>
                <DialogHeader>
                  <DialogTitle>{t('resetPassword')}</DialogTitle>
                </DialogHeader>
                <div className="space-y-3">
                  <div className="space-y-2">
                    <Label htmlFor="reset-pwd">{t('newPassword')}</Label>
                    <Input
                      id="reset-pwd"
                      type="password"
                      autoComplete="new-password"
                      value={resetPwd}
                      onChange={(e) => setResetPwd(e.target.value)}
                    />
                  </div>
                  <div className="space-y-2">
                    <Label htmlFor="reset-pwd-confirm">{t('confirmPassword')}</Label>
                    <Input
                      id="reset-pwd-confirm"
                      type="password"
                      autoComplete="new-password"
                      value={resetPwdConfirm}
                      onChange={(e) => setResetPwdConfirm(e.target.value)}
                    />
                  </div>
                </div>
                <DialogFooter>
                  <Button
                    variant="outline"
                    onClick={() => setResetUserId(null)}
                    disabled={resetSubmitting}
                  >
                    {tCommon('cancel')}
                  </Button>
                  <Button onClick={() => void submitResetPassword()} disabled={resetSubmitting}>
                    {resetSubmitting ? (
                      <>
                        <Loader2 className="h-4 w-4 me-2 animate-spin" />
                        {tCommon('loading')}
                      </>
                    ) : (
                      t('resetPassword')
                    )}
                  </Button>
                </DialogFooter>
              </DialogContent>
            </Dialog>

            <Dialog
              open={deleteUserId !== null}
              onOpenChange={(open) => {
                if (!open) setDeleteUserId(null);
              }}
            >
              <DialogContent className="sm:max-w-md" showCloseButton>
                <DialogHeader>
                  <DialogTitle>{t('deleteUser')}</DialogTitle>
                </DialogHeader>
                <p className="text-sm text-muted-foreground">{t('deleteUserConfirm')}</p>
                <DialogFooter>
                  <Button variant="outline" onClick={() => setDeleteUserId(null)} disabled={deleteSubmitting}>
                    {tCommon('cancel')}
                  </Button>
                  <Button variant="destructive" onClick={() => void submitDeleteUser()} disabled={deleteSubmitting}>
                    {deleteSubmitting ? (
                      <>
                        <Loader2 className="h-4 w-4 me-2 animate-spin" />
                        {tCommon('loading')}
                      </>
                    ) : (
                      t('deleteUser')
                    )}
                  </Button>
                </DialogFooter>
              </DialogContent>
            </Dialog>
          </TabsContent>
        ) : null}

        {canManageBranches(myProfile?.role) ? (
          <TabsContent value="branches" className="space-y-4">
            <Card>
              <CardHeader>
                <CardTitle>{t('branchesManage')}</CardTitle>
                <CardDescription>{t('branchesManageHint')}</CardDescription>
              </CardHeader>
              <CardContent className="space-y-6">
                <div className="grid gap-4 max-w-lg sm:grid-cols-2">
                  <div className="space-y-2 sm:col-span-2">
                    <Label>{t('nameAr')}</Label>
                    <Input
                      dir="rtl"
                      value={branchForm.name_ar}
                      onChange={(e) => setBranchForm((f) => ({ ...f, name_ar: e.target.value }))}
                    />
                  </div>
                  <div className="space-y-2 sm:col-span-2">
                    <Label>{t('nameEn')}</Label>
                    <Input
                      dir="ltr"
                      value={branchForm.name_en}
                      onChange={(e) => setBranchForm((f) => ({ ...f, name_en: e.target.value }))}
                    />
                  </div>
                  <div className="space-y-2 sm:col-span-2">
                    <Label>{t('branchAddress')}</Label>
                    <Input
                      value={branchForm.address}
                      onChange={(e) => setBranchForm((f) => ({ ...f, address: e.target.value }))}
                    />
                  </div>
                  <div className="space-y-2 sm:col-span-2">
                    <Label>{t('branchPhone')}</Label>
                    <Input
                      value={branchForm.phone}
                      onChange={(e) => setBranchForm((f) => ({ ...f, phone: e.target.value }))}
                    />
                  </div>
                </div>
                <Button onClick={() => void submitAddBranch()} disabled={branchSaving}>
                  {branchSaving ? tCommon('loading') : t('addBranch')}
                </Button>

                <div className="rounded-md border overflow-x-auto">
                  <Table>
                    <TableHeader>
                      <TableRow>
                        <TableHead>{t('nameAr')}</TableHead>
                        <TableHead>{t('nameEn')}</TableHead>
                        <TableHead>{t('branchAddress')}</TableHead>
                        <TableHead>{t('branchPhone')}</TableHead>
                        <TableHead className="w-[120px] text-end">{tCommon('actions')}</TableHead>
                      </TableRow>
                    </TableHeader>
                    <TableBody>
                      {allBranches.length === 0 ? (
                        <TableRow>
                          <TableCell colSpan={5} className="text-center text-muted-foreground">
                            {tCommon('noResults')}
                          </TableCell>
                        </TableRow>
                      ) : (
                        allBranches.map((b) => (
                          <TableRow key={b.id}>
                            <TableCell dir="rtl">{b.name_ar}</TableCell>
                            <TableCell dir="ltr">{b.name_en}</TableCell>
                            <TableCell>{b.address || '—'}</TableCell>
                            <TableCell>{b.phone || '—'}</TableCell>
                            <TableCell className="text-end">
                              <div className="flex justify-end gap-1">
                                <Button
                                  type="button"
                                  variant="ghost"
                                  size="icon"
                                  onClick={() => openEditBranch(b)}
                                  title={tCommon('edit')}
                                >
                                  <Edit className="h-4 w-4" />
                                </Button>
                                <Button
                                  type="button"
                                  variant="ghost"
                                  size="icon"
                                  className="text-destructive hover:text-destructive"
                                  disabled={b.id === DEFAULT_BRANCH_ID}
                                  title={tCommon('delete')}
                                  onClick={() => void deleteBranch(b.id)}
                                >
                                  <Trash2 className="h-4 w-4" />
                                </Button>
                              </div>
                            </TableCell>
                          </TableRow>
                        ))
                      )}
                    </TableBody>
                  </Table>
                </div>

                <Dialog
                  open={branchEditOpen}
                  onOpenChange={(open) => {
                    setBranchEditOpen(open);
                    if (!open) {
                      setBranchEditForm({ id: '', name_ar: '', name_en: '', address: '', phone: '' });
                    }
                  }}
                >
                  <DialogContent className="sm:max-w-md" showCloseButton>
                    <DialogHeader>
                      <DialogTitle>{t('editBranch')}</DialogTitle>
                    </DialogHeader>
                    <div className="grid gap-4 sm:grid-cols-2">
                      <div className="space-y-2 sm:col-span-2">
                        <Label>{t('nameAr')}</Label>
                        <Input
                          dir="rtl"
                          value={branchEditForm.name_ar}
                          onChange={(e) => setBranchEditForm((f) => ({ ...f, name_ar: e.target.value }))}
                        />
                      </div>
                      <div className="space-y-2 sm:col-span-2">
                        <Label>{t('nameEn')}</Label>
                        <Input
                          dir="ltr"
                          value={branchEditForm.name_en}
                          onChange={(e) => setBranchEditForm((f) => ({ ...f, name_en: e.target.value }))}
                        />
                      </div>
                      <div className="space-y-2 sm:col-span-2">
                        <Label>{t('branchAddress')}</Label>
                        <Input
                          value={branchEditForm.address}
                          onChange={(e) => setBranchEditForm((f) => ({ ...f, address: e.target.value }))}
                        />
                      </div>
                      <div className="space-y-2 sm:col-span-2">
                        <Label>{t('branchPhone')}</Label>
                        <Input
                          value={branchEditForm.phone}
                          onChange={(e) => setBranchEditForm((f) => ({ ...f, phone: e.target.value }))}
                        />
                      </div>
                    </div>
                    <DialogFooter>
                      <Button variant="outline" onClick={() => setBranchEditOpen(false)} disabled={branchSaving}>
                        {tCommon('cancel')}
                      </Button>
                      <Button onClick={() => void submitUpdateBranch()} disabled={branchSaving}>
                        {branchSaving ? tCommon('loading') : tCommon('save')}
                      </Button>
                    </DialogFooter>
                  </DialogContent>
                </Dialog>
              </CardContent>
            </Card>
          </TabsContent>
        ) : null}

        {myProfile?.role === 'admin' ? (
          <TabsContent value="integrations" className="space-y-6">
            <Card>
              <CardHeader>
                <CardTitle className="flex items-center gap-2">
                  <ImageIcon className="h-5 w-5" />
                  {t('brandingCardTitle')}
                </CardTitle>
                <CardDescription>{t('brandingCardHint')}</CardDescription>
              </CardHeader>
              <CardContent className="space-y-6 max-w-xl">
                <div className="flex flex-col gap-4 sm:flex-row sm:items-start">
                  <SiteLogo size={112} className="rounded-xl border bg-card p-2 shrink-0" />
                  <div className="flex flex-col gap-2 min-w-0">
                    <Label>{t('siteLogo')}</Label>
                    <Input
                      type="file"
                      accept="image/png,image/jpeg,image/webp,image/gif,image/svg+xml"
                      className="max-w-xs cursor-pointer"
                      disabled={logoUploading}
                      onChange={(e) => {
                        const f = e.target.files?.[0];
                        e.target.value = '';
                        if (f) void uploadSiteLogo(f);
                      }}
                    />
                    <p className="text-xs text-muted-foreground">{t('siteLogoHint')}</p>
                    <Button type="button" variant="outline" size="sm" className="w-fit" onClick={() => void removeSiteLogo()}>
                      {t('removeLogo')}
                    </Button>
                  </div>
                </div>

                <div className="space-y-3 border-t pt-6">
                  <div className="flex items-center gap-2">
                    <Building2 className="h-5 w-5" />
                    <span className="font-medium">{t('outletNames')}</span>
                  </div>
                  <p className="text-sm text-muted-foreground">{t('outletNamesHint')}</p>
                  <div className="space-y-2">
                    <Label htmlFor="outlet-en">{t('outletNameEn')}</Label>
                    <Input
                      id="outlet-en"
                      dir="ltr"
                      value={outletNameEn}
                      onChange={(e) => setOutletNameEn(e.target.value)}
                      disabled={integrationsLoading}
                    />
                  </div>
                  <div className="space-y-2">
                    <Label htmlFor="outlet-ar">{t('outletNameAr')}</Label>
                    <Input
                      id="outlet-ar"
                      dir="rtl"
                      value={outletNameAr}
                      onChange={(e) => setOutletNameAr(e.target.value)}
                      disabled={integrationsLoading}
                    />
                  </div>
                  <Button type="button" onClick={() => void saveOutletBranding()} disabled={outletSaving || integrationsLoading}>
                    {outletSaving ? tCommon('loading') : t('saveOutletNames')}
                  </Button>
                </div>
              </CardContent>
            </Card>

            <Card>
              <CardHeader>
                <CardTitle className="flex items-center gap-2">
                  <MessageSquare className="h-5 w-5" />
                  {t('telegramTitle')}
                </CardTitle>
                <CardDescription>{t('telegramHint')}</CardDescription>
              </CardHeader>
              <CardContent className="space-y-4 max-w-2xl">
                {integrationsLoading ? (
                  <Skeleton className="h-32 w-full" />
                ) : (
                  <>
                    <div className="space-y-2">
                      <Label htmlFor="tg-token">{t('telegramBotToken')}</Label>
                      <Input
                        id="tg-token"
                        type="password"
                        autoComplete="off"
                        value={telegramToken}
                        onChange={(e) => setTelegramToken(e.target.value)}
                        placeholder="123456789:AA..."
                      />
                    </div>
                    <div className="space-y-2">
                      <Label htmlFor="tg-chat">{t('telegramChatId')}</Label>
                      <Input
                        id="tg-chat"
                        autoComplete="off"
                        value={telegramChatId}
                        onChange={(e) => setTelegramChatId(e.target.value)}
                        placeholder="-100..."
                      />
                    </div>
                    <div className="space-y-2">
                      <Label htmlFor="tg-template">{t('telegramTemplate')}</Label>
                      <Textarea
                        id="tg-template"
                        rows={12}
                        className="font-mono text-sm"
                        value={telegramTemplate}
                        onChange={(e) => setTelegramTemplate(e.target.value)}
                      />
                      <div className="text-xs text-muted-foreground">
                        <p className="font-medium">{t('telegramPlaceholdersIntro')}</p>
                        <ul className="mt-2 list-none space-y-1 ps-0">
                          {(
                            [
                              ['{{branch_name}}', 'telegramPh_branch_name'],
                              ['{{user_name}}', 'telegramPh_user_name'],
                              ['{{order_date}}', 'telegramPh_order_date'],
                              ['{{supplier_name}}', 'telegramPh_supplier_name'],
                              ['{{total_amount}}', 'telegramPh_total_amount'],
                              ['{{items_list}}', 'telegramPh_items_list'],
                              ['{{po_short_id}}', 'telegramPh_po_short_id'],
                            ] as const
                          ).map(([token, descKey]) => (
                            <li key={token} className="flex flex-wrap gap-x-1 gap-y-0.5">
                              <code className="rounded bg-muted px-1 font-mono text-[0.7rem] text-foreground">{token}</code>
                              <span>—</span>
                              <span>{t(descKey)}</span>
                            </li>
                          ))}
                        </ul>
                      </div>
                    </div>
                    <Button type="button" onClick={() => void saveTelegramIntegration()} disabled={integrationsSaving}>
                      {integrationsSaving ? tCommon('loading') : tCommon('save')}
                    </Button>
                  </>
                )}
              </CardContent>
            </Card>
          </TabsContent>
        ) : null}

        <TabsContent value="categories" className="space-y-8">
          <Card>
            <CardHeader className="flex flex-col gap-2 sm:flex-row sm:items-center sm:justify-between">
              <div>
                <CardTitle>{t('recipeCategories')}</CardTitle>
                <CardDescription>{t('categoriesTitle')}</CardDescription>
              </div>
              <Button variant="outline" size="sm" onClick={() => openRecipeDialog(null)} disabled={categoriesLoading}>
                <Plus className="h-4 w-4 me-2" />
                {t('addRecipeCategory')}
              </Button>
            </CardHeader>
            <CardContent>
              {categoriesLoading ? (
                <Skeleton className="h-40 w-full" />
              ) : (
                <div className="rounded-md border overflow-x-auto">
                  <Table>
                    <TableHeader>
                      <TableRow>
                        <TableHead>{t('nameAr')}</TableHead>
                        <TableHead>{t('nameEn')}</TableHead>
                        <TableHead>{t('type')}</TableHead>
                        <TableHead>{t('sortOrder')}</TableHead>
                        <TableHead className="w-[120px]">{tCommon('actions')}</TableHead>
                      </TableRow>
                    </TableHeader>
                    <TableBody>
                      {recipeCategories.length === 0 ? (
                        <TableRow>
                          <TableCell colSpan={5} className="text-center text-muted-foreground">
                            {tCommon('noResults')}
                          </TableCell>
                        </TableRow>
                      ) : (
                        recipeCategories.map((c) => (
                          <TableRow key={c.id}>
                            <TableCell dir="rtl">{c.name_ar}</TableCell>
                            <TableCell dir="ltr">{c.name_en}</TableCell>
                            <TableCell>
                              {c.type === 'food' ? t('typeFood') : t('typeBeverage')}
                            </TableCell>
                            <TableCell>{c.sort_order}</TableCell>
                            <TableCell>
                              <div className="flex gap-1">
                                <Button variant="ghost" size="sm" onClick={() => openRecipeDialog(c)}>
                                  {tCommon('edit')}
                                </Button>
                                <Button variant="ghost" size="icon" onClick={() => deleteRecipeCategory(c.id)}>
                                  <Trash2 className="h-4 w-4 text-destructive" />
                                </Button>
                              </div>
                            </TableCell>
                          </TableRow>
                        ))
                      )}
                    </TableBody>
                  </Table>
                </div>
              )}
            </CardContent>
          </Card>

          <Card>
            <CardHeader className="flex flex-col gap-2 sm:flex-row sm:items-center sm:justify-between">
              <div>
                <CardTitle>{t('inventoryCategories')}</CardTitle>
                <CardDescription>{t('categoriesTitle')}</CardDescription>
              </div>
              <Button
                variant="outline"
                size="sm"
                onClick={() => openInventoryDialog(null)}
                disabled={categoriesLoading}
              >
                <Plus className="h-4 w-4 me-2" />
                {t('addInventoryCategory')}
              </Button>
            </CardHeader>
            <CardContent>
              {categoriesLoading ? (
                <Skeleton className="h-40 w-full" />
              ) : (
                <div className="rounded-md border overflow-x-auto">
                  <Table>
                    <TableHeader>
                      <TableRow>
                        <TableHead>{t('nameAr')}</TableHead>
                        <TableHead>{t('nameEn')}</TableHead>
                        <TableHead>{t('sortOrder')}</TableHead>
                        <TableHead className="w-[120px]">{tCommon('actions')}</TableHead>
                      </TableRow>
                    </TableHeader>
                    <TableBody>
                      {inventoryCategories.length === 0 ? (
                        <TableRow>
                          <TableCell colSpan={4} className="text-center text-muted-foreground">
                            {tCommon('noResults')}
                          </TableCell>
                        </TableRow>
                      ) : (
                        inventoryCategories.map((c) => (
                          <TableRow key={c.id}>
                            <TableCell dir="rtl">{c.name_ar}</TableCell>
                            <TableCell dir="ltr">{c.name_en}</TableCell>
                            <TableCell>{c.sort_order}</TableCell>
                            <TableCell>
                              <div className="flex gap-1">
                                <Button variant="ghost" size="sm" onClick={() => openInventoryDialog(c)}>
                                  {tCommon('edit')}
                                </Button>
                                {canDeleteInventoryCatalog(myProfile?.role) ? (
                                  <Button variant="ghost" size="icon" onClick={() => deleteInventoryCategory(c.id)}>
                                    <Trash2 className="h-4 w-4 text-destructive" />
                                  </Button>
                                ) : null}
                              </div>
                            </TableCell>
                          </TableRow>
                        ))
                      )}
                    </TableBody>
                  </Table>
                </div>
              )}
            </CardContent>
          </Card>
        </TabsContent>
      </Tabs>

      <Dialog open={recipeDialogOpen} onOpenChange={setRecipeDialogOpen}>
        <DialogContent className="sm:max-w-lg" showCloseButton>
          <DialogHeader>
            <DialogTitle>{recipeForm.id ? t('editRecipeCategory') : t('addRecipeCategory')}</DialogTitle>
          </DialogHeader>
          <div className="space-y-4">
            <div className="space-y-2">
              <Label>{t('nameAr')}</Label>
              <Input
                dir="rtl"
                value={recipeForm.name_ar}
                onChange={(e) => setRecipeForm((f) => ({ ...f, name_ar: e.target.value }))}
              />
            </div>
            <div className="space-y-2">
              <Label>{t('nameEn')}</Label>
              <Input
                dir="ltr"
                value={recipeForm.name_en}
                onChange={(e) => setRecipeForm((f) => ({ ...f, name_en: e.target.value }))}
              />
            </div>
            <div className="space-y-2">
              <Label>{t('type')}</Label>
              <Select
                value={recipeForm.type}
                onValueChange={(v) => setRecipeForm((f) => ({ ...f, type: v as RecipeType }))}
              >
                <SelectTrigger>
                  <SelectValue />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="food">{t('typeFood')}</SelectItem>
                  <SelectItem value="beverage">{t('typeBeverage')}</SelectItem>
                </SelectContent>
              </Select>
            </div>
            <div className="space-y-2">
              <Label>{t('sortOrder')}</Label>
              <Input
                type="number"
                value={recipeForm.sort_order}
                onChange={(e) => setRecipeForm((f) => ({ ...f, sort_order: e.target.value }))}
              />
            </div>
          </div>
          <DialogFooter>
            <Button variant="outline" onClick={() => setRecipeDialogOpen(false)}>
              {tCommon('cancel')}
            </Button>
            <Button onClick={saveRecipeCategory} disabled={categorySaving}>
              {categorySaving ? tCommon('loading') : tCommon('save')}
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>

      <Dialog open={inventoryDialogOpen} onOpenChange={setInventoryDialogOpen}>
        <DialogContent className="sm:max-w-lg" showCloseButton>
          <DialogHeader>
            <DialogTitle>{inventoryForm.id ? t('editInventoryCategory') : t('addInventoryCategory')}</DialogTitle>
          </DialogHeader>
          <div className="space-y-4">
            <div className="space-y-2">
              <Label>{t('nameAr')}</Label>
              <Input
                dir="rtl"
                value={inventoryForm.name_ar}
                onChange={(e) => setInventoryForm((f) => ({ ...f, name_ar: e.target.value }))}
              />
            </div>
            <div className="space-y-2">
              <Label>{t('nameEn')}</Label>
              <Input
                dir="ltr"
                value={inventoryForm.name_en}
                onChange={(e) => setInventoryForm((f) => ({ ...f, name_en: e.target.value }))}
              />
            </div>
            <div className="space-y-2">
              <Label>{t('sortOrder')}</Label>
              <Input
                type="number"
                value={inventoryForm.sort_order}
                onChange={(e) => setInventoryForm((f) => ({ ...f, sort_order: e.target.value }))}
              />
            </div>
          </div>
          <DialogFooter>
            <Button variant="outline" onClick={() => setInventoryDialogOpen(false)}>
              {tCommon('cancel')}
            </Button>
            <Button onClick={saveInventoryCategory} disabled={categorySaving}>
              {categorySaving ? tCommon('loading') : tCommon('save')}
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>
    </div>
  );
}
