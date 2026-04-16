const express = require("express");
const pool = require("../db");

const router = express.Router();

const authorNameSql = `COALESCE(NULLIF(TRIM(u.nickname), ''), CONCAT(LEFT(u.phone, 3), '****', RIGHT(u.phone, 4)))`;

function toArticleId(v) {
  const n = parseInt(String(v), 10);
  if (Number.isNaN(n) || n < 1) return null;
  return n;
}

function mapArticleDetail(row) {
  return {
    id: row.id,
    type: row.type,
    title: row.title,
    excerpt: row.excerpt,
    content: row.content,
    created_at: row.created_at,
    author: {
      id: row.author_id,
      name: row.author_name,
      avatar: row.author_avatar,
      headline: row.author_headline,
    },
    stats: {
      agree_count: row.agree_count,
      comment_count: row.comment_count,
      favorite_count: row.favorite_count,
      like_count: row.like_count,
    },
    tags: [],
    user_interactions: {
      has_upvoted: false,
      has_collected: false,
      has_liked: false,
      is_following_author: false,
    },
  };
}

/**
 * GET /api/articles/:id
 */
router.get("/:id", async (req, res) => {
  const id = toArticleId(req.params.id);
  if (id == null) {
    return res.status(400).json({
      success: false,
      code: 40001,
      message: "文章 id 不合法",
    });
  }

  try {
    const [rows] = await pool.query(
      `SELECT
         fi.id,
         fi.type,
         fi.title,
         fi.excerpt,
         COALESCE(fi.content, fi.excerpt) AS content,
         fi.agree_count,
         fi.comment_count,
         fi.favorite_count,
         fi.like_count,
         fi.created_at,
         u.id AS author_id,
         ${authorNameSql} AS author_name,
         u.avatar AS author_avatar,
         u.headline AS author_headline
       FROM feed_item fi
       INNER JOIN user u ON u.id = fi.author_id
       WHERE fi.id = ? AND fi.type = 'article'
       LIMIT 1`,
      [id]
    );

    const row = rows[0];
    if (!row) {
      return res.status(404).json({
        success: false,
        code: 40401,
        message: "文章不存在或已删除",
      });
    }

    return res.json({
      success: true,
      code: 0,
      message: "ok",
      data: mapArticleDetail(row),
    });
  } catch (err) {
    const code = err && err.code;
    if (code === "ER_BAD_FIELD_ERROR") {
      console.error(
        "[articles/:id] 缺少 content 字段，请在 MySQL 执行 sql/feed_item_content.sql 中的 ALTER"
      );
      return res.status(500).json({
        success: false,
        code: 50001,
        message: "数据库未升级：缺少 feed_item.content 字段，请执行 sql/feed_item_content.sql",
      });
    }
    console.error("[articles/:id]", err);
    return res.status(500).json({
      success: false,
      code: 50000,
      message: "服务器繁忙，请稍后再试",
    });
  }
});

module.exports = router;
