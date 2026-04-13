-- Treat missing stock_levels like zero qty / zero threshold (matches client defaults).
CREATE OR REPLACE VIEW daily_stock_summary AS
SELECT
  ii.id AS item_id,
  ii.name_ar,
  ii.name_en,
  ii.unit,
  COALESCE(sl.current_quantity, 0::decimal(10, 3)) AS current_quantity,
  COALESCE(sl.zero_stock_level, 0::decimal(10, 3)) AS zero_stock_level,
  CASE
    WHEN COALESCE(sl.current_quantity, 0) <= 0 THEN 'out_of_stock'
    WHEN COALESCE(sl.current_quantity, 0) <= COALESCE(sl.zero_stock_level, 0) THEN 'low_stock'
    ELSE 'in_stock'
  END AS stock_status,
  COALESCE((
    SELECT SUM(dc.quantity_used)
    FROM daily_consumption dc
    WHERE dc.item_id = ii.id AND dc.consumption_date = CURRENT_DATE
  ), 0) AS today_consumed,
  COALESCE((
    SELECT SUM(wl.quantity)
    FROM waste_logs wl
    WHERE wl.item_id = ii.id AND wl.waste_date = CURRENT_DATE
  ), 0) AS today_wasted,
  COALESCE((
    SELECT SUM(st.quantity)
    FROM stock_transactions st
    WHERE st.item_id = ii.id
      AND st.transaction_type = 'received'
      AND st.created_at::date = CURRENT_DATE
  ), 0) AS today_received,
  ii.branch_id
FROM inventory_items ii
LEFT JOIN stock_levels sl ON sl.item_id = ii.id
WHERE ii.is_active = true;
