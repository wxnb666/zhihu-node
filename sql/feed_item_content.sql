-- 旧库补列：在库 zhihu 中执行（若列已存在会报错，可忽略）
ALTER TABLE `feed_item`
  ADD COLUMN `content` MEDIUMTEXT NULL COMMENT '正文（HTML/Markdown），为空时接口回退为 excerpt' AFTER `excerpt`;

-- 补列后若要一批示例列表 + 长正文，请执行 sql/seed_feed_articles.sql
