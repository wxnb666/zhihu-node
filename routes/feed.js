const express = require("express");
const pool = require("../db");

const router = express.Router();

function toInt(v, def, max) {
  const n = parseInt(String(v), 10);
  if (Number.isNaN(n) || n < 1) return def;
  return Math.min(n, max);
}

function mapFeedRow(row) {
  return {
    id: row.id,
    type: row.type,
    title: row.title,
    excerpt: row.excerpt,
    agree_count: row.agree_count,
    comment_count: row.comment_count,
    favorite_count: row.favorite_count,
    like_count: row.like_count,
    created_at: row.created_at,
    author: {
      id: row.author_id,
      name: row.author_name,
      avatar: row.author_avatar,
      headline: row.author_headline,
    },
  };
}

/**
 * GET /api/feed/recommend?page=1&page_size=10
 */
router.get("/recommend", async (req, res) => {
  const page = toInt(req.query.page, 1, 10_000);
  const pageSize = toInt(req.query.page_size ?? req.query.pageSize, 10, 50);
  const offset = (page - 1) * pageSize;

  const authorNameSql = `COALESCE(NULLIF(TRIM(u.nickname), ''), CONCAT(LEFT(u.phone, 3), '****', RIGHT(u.phone, 4)))`;

  try {
    const [[{ total }]] = await pool.query(
      `SELECT COUNT(*) AS total
       FROM feed_item fi
       INNER JOIN user u ON u.id = fi.author_id`
    );

    const [rows] = await pool.query(
      `SELECT
         fi.id,
         fi.type,
         fi.title,
         fi.excerpt,
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
       ORDER BY fi.created_at DESC, fi.id DESC
       LIMIT ? OFFSET ?`,
      [pageSize, offset]
    );

    return res.json({
      success: true,
      code: 0,
      message: "ok",
      data: {
        list: rows.map(mapFeedRow),
        page,
        page_size: pageSize,
        total: Number(total) || 0,
      },
    });
  } catch (err) {
    console.error("[feed/recommend]", err);
    return res.status(500).json({
      success: false,
      code: 50000,
      message: "服务器繁忙，请稍后再试",
    });
  }
});

module.exports = router;
