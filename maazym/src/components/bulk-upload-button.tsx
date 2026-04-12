'use client';

import { useId, useRef, useState } from 'react';
import { useTranslations } from 'next-intl';
import { Button } from '@/components/ui/button';
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogFooter } from '@/components/ui/dialog';
import { Alert, AlertDescription } from '@/components/ui/alert';
import { Badge } from '@/components/ui/badge';
import { Download, Upload, FileSpreadsheet, CheckCircle, AlertCircle, Loader2 } from 'lucide-react';
import { downloadTemplate, parseExcelFile, type TemplateType } from '@/lib/excel/templates';
import { toast } from 'sonner';

interface BulkUploadButtonProps {
  templateType: TemplateType;
  onUploadComplete?: () => void;
}

export function BulkUploadButton({ templateType, onUploadComplete }: BulkUploadButtonProps) {
  const t = useTranslations('bulkUpload');
  const tCommon = useTranslations('common');
  const fileInputId = useId();
  const [dialogOpen, setDialogOpen] = useState(false);
  const [uploading, setUploading] = useState(false);
  const [result, setResult] = useState<{
    inserted: number;
    updated: number;
    errors: string[];
    total: number;
  } | null>(null);
  const fileRef = useRef<HTMLInputElement>(null);

  async function handleUpload(e: React.ChangeEvent<HTMLInputElement>) {
    const file = e.target.files?.[0];
    if (!file) return;

    setUploading(true);
    setResult(null);

    try {
      const sheets = await parseExcelFile(file);
      const sheetName = Object.keys(sheets)[0];
      const rows = sheets[sheetName];

      if (!rows || rows.length < 2) {
        toast.error(t('emptyFile'));
        setUploading(false);
        return;
      }

      const dataRows = rows.slice(1).filter((row: unknown[]) =>
        row.some((cell: unknown) => cell != null && cell !== '')
      );

      const res = await fetch('/api/bulk-upload', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ type: templateType, rows: dataRows }),
      });

      const data = await res.json();

      if (!res.ok) {
        toast.error(data.error || tCommon('error'));
        setUploading(false);
        return;
      }

      const ins = Number(data.inserted) || 0;
      const upd = Number(data.updated) || 0;
      setResult({
        inserted: ins,
        updated: upd,
        errors: data.errors ?? [],
        total: data.total ?? 0,
      });
      if (ins > 0 || upd > 0) {
        if (ins > 0 && upd > 0) {
          toast.success(t('insertedAndUpdated', { inserted: ins, updated: upd }));
        } else if (ins > 0) {
          toast.success(t('inserted', { count: ins }));
        } else {
          toast.success(t('updated', { count: upd }));
        }
        onUploadComplete?.();
      }
    } catch (err: unknown) {
      const message = err instanceof Error ? err.message : tCommon('error');
      toast.error(message);
    } finally {
      setUploading(false);
      if (fileRef.current) fileRef.current.value = '';
    }
  }

  return (
    <>
      <div className="flex gap-2">
        <Button variant="outline" size="sm" onClick={() => downloadTemplate(templateType)}>
          <Download className="h-4 w-4 me-2" />
          {t('downloadTemplate')}
        </Button>
        <Button variant="outline" size="sm" onClick={() => setDialogOpen(true)}>
          <Upload className="h-4 w-4 me-2" />
          {t('uploadFile')}
        </Button>
      </div>

      <Dialog open={dialogOpen} onOpenChange={setDialogOpen}>
        <DialogContent>
          <DialogHeader>
            <DialogTitle className="flex items-center gap-2">
              <FileSpreadsheet className="h-5 w-5" />
              {t('uploadFile')}
            </DialogTitle>
          </DialogHeader>

          <div className="space-y-4">
            <div className="border-2 border-dashed rounded-lg p-6 text-center">
              <input
                ref={fileRef}
                type="file"
                accept=".xlsx,.xls"
                onChange={handleUpload}
                className="hidden"
                id={fileInputId}
                disabled={uploading}
              />
              <label htmlFor={fileInputId} className="cursor-pointer space-y-2">
                {uploading ? (
                  <Loader2 className="h-8 w-8 mx-auto animate-spin text-muted-foreground" />
                ) : (
                  <Upload className="h-8 w-8 mx-auto text-muted-foreground" />
                )}
                <p className="text-sm text-muted-foreground">
                  {uploading ? t('processing') : t('selectFile')}
                </p>
              </label>
            </div>

            {result && (
              <div className="space-y-3">
                <div className="flex flex-col gap-1">
                  <div className="flex items-center gap-2 flex-wrap">
                    <CheckCircle className="h-4 w-4 text-green-600 shrink-0" />
                    <Badge variant="secondary">
                      {result.total} {tCommon('total')}
                    </Badge>
                  </div>
                  {result.inserted > 0 && (
                    <span className="text-sm font-medium ps-6">{t('inserted', { count: result.inserted })}</span>
                  )}
                  {result.updated > 0 && (
                    <span className="text-sm font-medium ps-6">{t('updated', { count: result.updated })}</span>
                  )}
                  {result.inserted === 0 && result.updated === 0 && (
                    <span className="text-sm text-muted-foreground ps-6">{t('noRowsChanged')}</span>
                  )}
                </div>

                {result.errors.length > 0 && (
                  <Alert variant="destructive">
                    <AlertCircle className="h-4 w-4" />
                    <AlertDescription>
                      <p className="font-medium mb-1">{t('errorsFound', { count: result.errors.length })}</p>
                      <ul className="text-xs space-y-0.5 max-h-32 overflow-y-auto">
                        {result.errors.map((err, i) => (
                          <li key={i}>{err}</li>
                        ))}
                      </ul>
                    </AlertDescription>
                  </Alert>
                )}

                {result.errors.length === 0 && (
                  <Alert>
                    <CheckCircle className="h-4 w-4" />
                    <AlertDescription>{t('noErrors')}</AlertDescription>
                  </Alert>
                )}
              </div>
            )}
          </div>

          <DialogFooter>
            <Button
              variant="outline"
              onClick={() => {
                setDialogOpen(false);
                setResult(null);
              }}
            >
              {tCommon('close')}
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>
    </>
  );
}
