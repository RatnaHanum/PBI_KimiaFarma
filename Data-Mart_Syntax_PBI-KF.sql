  WITH tmp AS (
                SELECT  
                      *,
                        CASE WHEN price <= 50000 THEN 0.10
                              WHEN price > 50000 AND price <= 100000 THEN 0.15
                              WHEN price > 100000 AND price <= 300000 THEN 0.20
                              WHEN price > 300000 AND price <= 500000 THEN 0.25
                              WHEN price > 500000 THEN 0.30
                              ELSE 0
                              END AS persentase_gross_laba
                FROM `data.kf_final_transaction`
              )
SELECT 
        transaction_id,
        date,
        tmp.branch_id,
        branch_name,
        kota,
        provinsi,
        kc.rating AS rating_cabang,
        customer_name,
        p.product_id,
        p.product_name,
        tmp.price AS actual_price,
        discount_percentage,
        persentase_gross_laba,
        tmp.price - (tmp.price * discount_percentage) AS nett_sales,
        tmp.price - (tmp.price * persentase_gross_laba) AS nett_profit,
        tmp.rating AS rating_transaksi
FROM tmp
    JOIN `data.kf_inventory` AS i
        ON tmp.branch_id = i.branch_id
    JOIN `data.kf_kantor_cabang` AS kc
        ON tmp.branch_id = kc.branch_id
    JOIN `data.kf_product` AS p
        ON tmp.product_id = p.product_id
GROUP BY 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16
ORDER BY date ASC