-- 在库 zhihu 中执行（Navicat 查询窗口运行即可）
-- 建表与热搜完成后，请再执行 sql/seed_feed_articles.sql 填充推荐流（多篇带正文）。

-- 用户展示字段（已存在会报错，可忽略对应行）
ALTER TABLE `user`
  ADD COLUMN `nickname` VARCHAR(100) NULL DEFAULT NULL COMMENT '昵称' AFTER `phone`,
  ADD COLUMN `avatar` VARCHAR(500) NULL DEFAULT NULL COMMENT '头像URL' AFTER `nickname`,
  ADD COLUMN `headline` VARCHAR(200) NULL DEFAULT NULL COMMENT '一句话介绍' AFTER `avatar`;

-- 推荐流：问题 / 文章
CREATE TABLE IF NOT EXISTS `feed_item` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `type` ENUM('question','article') NOT NULL DEFAULT 'article' COMMENT '内容类型',
  `title` VARCHAR(500) NOT NULL,
  `excerpt` TEXT NULL COMMENT '列表摘要',
  `content` MEDIUMTEXT NULL COMMENT '正文（HTML/Markdown），为空时详情接口回退为 excerpt',
  `author_id` INT NOT NULL,
  `agree_count` INT UNSIGNED NOT NULL DEFAULT 0,
  `comment_count` INT UNSIGNED NOT NULL DEFAULT 0,
  `favorite_count` INT UNSIGNED NOT NULL DEFAULT 0,
  `like_count` INT UNSIGNED NOT NULL DEFAULT 0,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_feed_created` (`created_at`),
  KEY `idx_feed_author` (`author_id`),
  KEY `idx_feed_type` (`type`),
  CONSTRAINT `fk_feed_item_author` FOREIGN KEY (`author_id`) REFERENCES `user` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 大家都在搜（热搜）
CREATE TABLE IF NOT EXISTS `hot_search` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `keyword` VARCHAR(200) NOT NULL,
  `heat_text` VARCHAR(50) NOT NULL DEFAULT '' COMMENT '如 108 万',
  `tag` VARCHAR(10) NULL DEFAULT NULL COMMENT '热/新/沸',
  `sort_order` INT NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `idx_hot_sort` (`sort_order`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 示例热搜（可重复执行：先清空再插入）
TRUNCATE TABLE `hot_search`;
INSERT INTO `hot_search` (`keyword`, `heat_text`, `tag`, `sort_order`) VALUES
('美以袭击伊朗', '108 万', '热', 1),
('人工智能泡沫', '96 万', '沸', 2),
('前端开发还有前途吗', '732 万', '新', 3),
('程序员如何副业', '24 万', NULL, 4),
('这波 AI 浪潮怎么看', '15 万', '热', 5);

-- 推荐流示例（多篇「文章/问题」+ 较长正文 content）：执行 sql/seed_feed_articles.sql
-- 依赖：至少有一条 `user` 记录（会用 id 最小的用户作为 author）
