import type { UserRole } from '@/types/database';

/** Roles that may see money fields (PO totals, unit prices, reports spend, pricing settings, inventory unit cost). */
export function canViewFinancials(role: UserRole | null | undefined): boolean {
  return role === 'admin' || role === 'manager' || role === 'purchasing_manager';
}

/** Suppliers navigation and page access. */
export function canAccessSuppliers(role: UserRole | null | undefined): boolean {
  return role === 'admin' || role === 'manager' || role === 'purchasing_manager';
}

/** Reports navigation and page access. */
export function canAccessReports(role: UserRole | null | undefined): boolean {
  return role === 'admin' || role === 'manager' || role === 'purchasing_manager';
}

/** Promotions pricing tools: simulator, calculator, compare (cost/margin views). */
export function canAccessPriceSimulator(role: UserRole | null | undefined): boolean {
  return role === 'admin' || role === 'manager' || role === 'purchasing_manager';
}

export function canManageBranches(role: UserRole | null | undefined): boolean {
  return role === 'admin';
}

/** Delete inventory items / inventory categories (settings). */
export function canDeleteInventoryCatalog(role: UserRole | null | undefined): boolean {
  return role === 'admin';
}

/** Receive goods into stock from a submitted PO. */
export function canReceivePurchaseOrder(role: UserRole | null | undefined): boolean {
  return role === 'admin' || role === 'manager' || role === 'purchasing_manager';
}

/** Settings → Users tab (admin: all users; manager: non-admin staff only in UI). */
export function canAccessUsersSettings(role: UserRole | null | undefined): boolean {
  return role === 'admin' || role === 'manager';
}
