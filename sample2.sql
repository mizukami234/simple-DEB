-- お金の移動を表すテーブル

CREATE TABLE moves
( "from" TEXT NOT NULL
, "to" TEXT NOT NULL
, "amount" INTEGER NOT NULL
)
;

-- 移動の例

INSERT INTO moves("from", "to", "amount")
VALUES
  ('純資産', '資産', 10000000) --  事業開始
, ('負債', '資産', 5000000) -- 事業開始のための借り入れ
, ('資産', '費用',3000000) -- 費用発生など
, ('売上', '資産', 1000000) -- 売上
, ('資産', '費用',50000) -- 借り入れ利息の支払い
, ('資産', '費用',1500000) -- 費用発生など
, ('売上', '資産', 1300000) -- 売上
, ('資産', '費用',50000) -- 借り入れ利息の支払い
, ('資産', '費用',1200000) -- 費用発生など
, ('売上', '資産', 2000000) -- 売上
, ('資産', '費用',50000) -- 借り入れ利息の支払い
;

.mode table

CREATE VIEW sales(value) AS
  SELECT
  ( (SELECT COALESCE(SUM(amount), 0) FROM moves m WHERE m."from" = '売上')
  - (SELECT COALESCE(SUM(amount), 0) FROM moves m WHERE m."to" = '売上')
  ) AS value
;
CREATE VIEW cost(value) AS
  SELECT
  ( (SELECT COALESCE(SUM(amount), 0) FROM moves m WHERE m."to" = '費用')
  - (SELECT COALESCE(SUM(amount), 0) FROM moves m WHERE m."from" = '費用')
  ) AS value
;

SELECT
  (SELECT value FROM sales) AS "収益"
, (SELECT value FROM cost) AS "費用"
, (SELECT value FROM sales) - (SELECT value FROM cost) AS "利益"
;

CREATE VIEW assets(value) AS
  SELECT
    ( (SELECT COALESCE(SUM(amount), 0) FROM moves m WHERE m."to" = '資産')
    - (SELECT COALESCE(SUM(amount), 0) FROM moves m WHERE m."from" = '資産')
    ) AS value
;
CREATE VIEW liabilities(value) AS
  SELECT
    ( (SELECT COALESCE(SUM(amount), 0) FROM moves m WHERE m."from" = '負債')
    - (SELECT COALESCE(SUM(amount), 0) FROM moves m WHERE m."to" = '負債')
    ) AS value
;
CREATE VIEW equities(value) AS
  SELECT
    ( (SELECT COALESCE(SUM(amount), 0) FROM moves m WHERE m."from" = '純資産')
    - (SELECT COALESCE(SUM(amount), 0) FROM moves m WHERE m."to" = '純資産')
    ) AS value
;

SELECT
  (SELECT value FROM assets) AS "資産"
, (SELECT value FROM liabilities) AS "負債"
, (SELECT value FROM equities) AS "純資産"
, (SELECT value FROM liabilities) + (SELECT value FROM equities) AS "負債+純資産合計"
;

INSERT INTO moves("from", "to", "amount")
VALUES
  ('費用', '純資産', 5850000) -- 決算振替仕訳による費用の確定
, ('純資産', '売上', 4300000) -- 決算振替仕訳による売上の確定
;

SELECT
  (SELECT value FROM sales) AS "収益"
, (SELECT value FROM cost) AS "費用"
, (SELECT value FROM sales) - (SELECT value FROM cost) AS "利益"
;

SELECT
  (SELECT value FROM assets) AS "資産"
, (SELECT value FROM liabilities) AS "負債"
, (SELECT value FROM equities) AS "純資産"
, (SELECT value FROM liabilities) + (SELECT value FROM equities) AS "負債+純資産合計"
;
