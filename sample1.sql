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
  ('現金', '費用', 600) -- 諸々の初期費用がかかりました
, ('現金', '費用', 500) -- 仕入れがありました
, ('売上', '現金', 200) -- 200円のコーヒーが売れました
, ('売上', '現金', 300) -- 300円のクッキーが売れました
, ('売上', '現金', 200) -- 200円のコーヒーが売れました
, ('売上', '現金', 200) -- 200円のコーヒーが売れました
, ('売上', '現金', 500) -- 500円のケーキが売れました
, ('売上', '現金', 200) -- 200円のコーヒーが売れました
, ('売上', '現金', 300) -- 300円のクッキーが売れました
, ('現金', '費用', 600) -- 給料を支払いました
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
, (SELECT value FROM cost) AS "コスト"
, (SELECT value FROM sales) - (SELECT value FROM cost) AS "利益"

