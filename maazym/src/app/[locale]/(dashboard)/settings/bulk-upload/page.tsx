'use client';

import { useRef, useState } from 'react';
import { useTranslations, useLocale } from 'next-intl';
import Link from 'next/link';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import {
  Package, Truck, UtensilsCrossed, BarChart3,
  ShoppingCart, Trash2, Download, Upload,
  Loader2, CheckCircle2, AlertCircle, ArrowLeft,
} from 'lucide-react';
import { toast } from 'sonner';
import { downloadTemplate, parseExcelFile, type TemplateType } from '@/lib/excel/templates';

interface UploadResult {
  inserted: number;
  updated: number;
  errors: string[];
  total: number;
}

const TEMPLATE_CARDS: {
  type: TemplateType;
  icon: typeof Package;
  titleKey: string;
  descKey: string;
}[] = [
  { type: 'inventory_items', icon: Package, titleKey: 'inventoryItems', descKey: 'inventoryItemsDesc' },
  { type: 'suppliers', icon: Truck, titleKey: 'suppliers', descKey: 'suppliersDesc' },
  { type: 'menu_items', icon: UtensilsCrossed, titleKey: 'menuItems', descKey: 'menuItemsDesc' },
  { type: 'current_stock', icon: BarChart3, titleKey: 'currentStock', descKey: 'currentStockDesc' },
  { type: 'purchase_orders', icon: ShoppingCart, titleKey: 'purchaseOrders', descKey: 'purchaseOrdersDesc' },
  { type: 'waste_logs', icon: Trash2, titleKey: 'wasteLogs', descKey: 'wasteLogsDesc' },
];

export default function BulkUploadPage() {
  const t = useTranslations('bulkUpload');
  const tCommon = useTranslations('common');
  const locale = useLocale();
  const isRtl = locale === 'ar';

  const [files, setFiles] = useState<Record<TemplateType, File | null>>({
    inventory_items: null,
    suppliers: null,
    menu_items: null,
    current_stock: null,
    purchase_orders: null,
    waste_logs: null,
  });
  const [uploading, setUploading] = useState<Record<string, boolean>>({});
  const [results, setResults] = useState<Record<string, UploadResult>>({});
  const fileInputRefs = useRef<Record<string, HTMLInputElement | null>>({});

  function handleFileChange(type: TemplateType, fileList: FileList | null) {
    const file = fileList?.[0] ?? null;
    setFiles((prev) => ({ ...prev, [type]: file }));
    setResults((prev) => {
      const next = { ...prev };
      delete next[type];
      return next;
    });
  }

  async function handleUpload(type: TemplateType) {
    const file = files[type];
    if (!file) {
      toast.error(t('selectFile'));
      return;
    }

    setUploading((prev) => ({ ...prev, [type]: true }));
    try {
      const sheets = await parseExcelFile(file);
      const sheetData = Object.values(sheets)[0];
      if (!sheetData || sheetData.length < 2) {
        toast.error(t('selectFile'));
        setUploading((prev) => ({ ...prev, [type]: false }));
        return;
      }

      const rows = sheetData.slice(1).filter((row) =>
        row.some((cell: any) => cell !== null && cell !== undefined && String(cell).trim() !== '')
      );

      const res = await fetch('/api/bulk-upload', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ type, rows }),
      });

      const json = await res.json();
      if (!res.ok) {
        toast.error(json.error || tCommon('error'));
        setUploading((prev) => ({ ...prev, [type]: false }));
        return;
      }

      const ins = Number(json.inserted) || 0;
      const upd = Number(json.updated) || 0;
      setResults((prev) => ({
        ...prev,
        [type]: {
          inserted: ins,
          updated: upd,
          errors: json.errors ?? [],
          total: json.total ?? 0,
        },
      }));
      if (ins > 0 && upd > 0) {
        toast.success(t('insertedAndUpdated', { inserted: ins, updated: upd }));
      } else if (ins > 0) {
        toast.success(t('inserted', { count: ins }));
      } else if (upd > 0) {
        toast.success(t('updated', { count: upd }));
      }
      if (json.errors?.length > 0) {
        toast.warning(t('errorsFound', { count: json.errors.length }));
      }
    } catch {
      toast.error(tCommon('error'));
    } finally {
      setUploading((prev) => ({ ...prev, [type]: false }));
    }
  }

  return (
    <div className="space-y-6">
      <div className="flex items-center gap-4">
        <Link href={`/${locale}/settings`}>
          <Button variant="ghost" size="icon">
            <ArrowLeft className={isRtl ? 'rotate-180' : ''} />
          </Button>
        </Link>
        <div>
          <h1 className="text-2xl font-bold">{t('title')}</h1>
          <p className="text-muted-foreground">{t('subtitle')}</p>
        </div>
      </div>

      <div className="grid gap-6 md:grid-cols-2 lg:grid-cols-3">
        {TEMPLATE_CARDS.map(({ type, icon: Icon, titleKey, descKey }) => {
          const result = results[type];
          const isUploading = uploading[type];
          const selectedFile = files[type];

          return (
            <Card key={type} className="flex flex-col">
              <CardHeader>
                <div className="flex items-center gap-3">
                  <div className="flex h-10 w-10 shrink-0 items-center justify-center rounded-lg bg-primary/10 text-primary">
                    <Icon className="h-5 w-5" />
                  </div>
                  <div>
                    <CardTitle className="text-base">{t(titleKey)}</CardTitle>
                    <CardDescription className="text-xs">{t(descKey)}</CardDescription>
                  </div>
                </div>
              </CardHeader>
              <CardContent className="flex flex-1 flex-col gap-3">
                <Button
                  variant="outline"
                  size="sm"
                  className="w-full"
                  onClick={() => downloadTemplate(type)}
                >
                  <Download className="h-4 w-4 me-2" />
                  {t('downloadTemplate')}
                </Button>

                <div className="space-y-2">
                  <Input
                    ref={(el) => { fileInputRefs.current[type] = el; }}
                    type="file"
                    accept=".xlsx,.xls"
                    className="text-xs"
                    onChange={(e) => handleFileChange(type, e.target.files)}
                  />
                  {selectedFile && (
                    <p className="text-xs text-muted-foreground truncate">
                      {selectedFile.name}
                    </p>
                  )}
                </div>

                <Button
                  size="sm"
                  className="w-full"
                  disabled={!selectedFile || isUploading}
                  onClick={() => void handleUpload(type)}
                >
                  {isUploading ? (
                    <>
                      <Loader2 className="h-4 w-4 me-2 animate-spin" />
                      {t('processing')}
                    </>
                  ) : (
                    <>
                      <Upload className="h-4 w-4 me-2" />
                      {t('uploadFile')}
                    </>
                  )}
                </Button>

                {result && (
                  <div className="mt-2 space-y-2 rounded-md border p-3 text-sm">
                    <p className="font-medium">{t('results')}</p>
                    {result.inserted > 0 && (
                      <div className="flex items-center gap-2 text-green-700 dark:text-green-400">
                        <CheckCircle2 className="h-4 w-4 shrink-0" />
                        <span>{t('inserted', { count: result.inserted })}</span>
                      </div>
                    )}
                    {result.updated > 0 && (
                      <div className="flex items-center gap-2 text-green-700 dark:text-green-400">
                        <CheckCircle2 className="h-4 w-4 shrink-0" />
                        <span>{t('updated', { count: result.updated })}</span>
                      </div>
                    )}
                    {result.inserted === 0 && result.updated === 0 && (
                      <div className="flex items-center gap-2 text-muted-foreground">
                        <CheckCircle2 className="h-4 w-4 shrink-0" />
                        <span>{t('noRowsChanged')}</span>
                      </div>
                    )}
                    {result.errors.length > 0 ? (
                      <div className="space-y-1">
                        <div className="flex items-center gap-2 text-destructive">
                          <AlertCircle className="h-4 w-4 shrink-0" />
                          <span>{t('errorsFound', { count: result.errors.length })}</span>
                        </div>
                        <ul className="max-h-32 overflow-y-auto space-y-0.5 text-xs text-muted-foreground ps-6 list-disc">
                          {result.errors.map((err, idx) => (
                            <li key={idx}>{err}</li>
                          ))}
                        </ul>
                      </div>
                    ) : (
                      <div className="flex items-center gap-2 text-green-700 dark:text-green-400">
                        <CheckCircle2 className="h-4 w-4 shrink-0" />
                        <span>{t('noErrors')}</span>
                      </div>
                    )}
                  </div>
                )}
              </CardContent>
            </Card>
          );
        })}
      </div>
    </div>
  );
}
