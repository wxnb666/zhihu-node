const express = require("express");
const pool = require("../db");

const router = express.Router();

/** @param {string} raw */
function likePattern(raw) {
  const s = String(raw).trim().slice(0, 100);
  if (!s) return null;
  const escaped = s.replace(/\\/g, "\\\\").replace(/%/g, "\\%").replace(/_/g, "\\_");
  return `%${escaped}%`;
}

function toLimit(v, def, max) {
  const n = parseInt(String(v), 10);
  if (Number.isNaN(n) || n < 1) return def;
  return Math.min(n, max);
}

const authorNameSql = `COALESCE(NULLIF(TRIM(u.nickname), ''), CONCAT(LEFT(u.phone, 3), '****', RIGHT(u.phone, 4)))`;

function mapContentRow(row) {
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
 * GET /api/search?q=关键词&type=all|question|article|user&limit=10
 */
router.get("/", async (req, res) => {
  const q = req.query.q ?? req.query.keyword;
  const pattern = likePattern(q == null ? "" : q);
  if (!pattern) {
    return res.status(400).json({
      success: false,
      code: 40001,
      message: "请输入搜索关键词",
    });
  }

  const type = String(req.query.type || "all").toLowerCase();
  const limit = toLimit(req.query.limit, 10, 30);

  const empty = () => ({
    questions: [],
    articles: [],
    users: [],
  });

  try {
    const data = {
      keyword: String(q).trim().slice(0, 100),
      ...empty(),
    };

    const searchContent = async (contentType) => {
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
         WHERE fi.type = ?
           AND (fi.title LIKE ? ESCAPE '\\\\' OR fi.excerpt LIKE ? ESCAPE '\\\\')
         ORDER BY fi.agree_count DESC, fi.created_at DESC
         LIMIT ?`,
        [contentType, pattern, pattern, limit]
      );
      return rows.map(mapContentRow);
    };

    const searchUsers = async () => {
      const [rows] = await pool.query(
        `SELECT
           u.id,
           ${authorNameSql} AS name,
           u.avatar,
           u.headline
         FROM user u
         WHERE u.nickname LIKE ? ESCAPE '\\\\'
            OR u.phone LIKE ? ESCAPE '\\\\'
         ORDER BY u.id DESC
         LIMIT ?`,
        [pattern, pattern, limit]
      );
      return rows.map((r) => ({
        id: r.id,
        name: r.name,
        avatar: r.avatar,
        headline: r.headline,
      }));
    };

    if (type === "all") {
      const [questions, articles, users] = await Promise.all([
        searchContent("question"),
        searchContent("article"),
        searchUsers(),
      ]);
      data.questions = questions;
      data.articles = articles;
      data.users = users;
    } else if (type === "question") {
      data.questions = await searchContent("question");
    } else if (type === "article") {
      data.articles = await searchContent("article");
    } else if (type === "user") {
      data.users = await searchUsers();
    } else {
      return res.status(400).json({
        success: false,
        code: 40002,
        message: "type 只能是 all、question、article、user",
      });
    }

    return res.json({
      success: true,
      code: 0,
      message: "ok",
      data,
    });
  } catch (err) {
    console.error("[search]", err);
    return res.status(500).json({
      success: false,
      code: 50000,
      message: "服务器繁忙，请稍后再试",
    });
  }
});

/**
 * GET /api/search/hot?shuffle=1
 * 大家都在搜
 */
router.get("/hot", async (req, res) => {
  const shuffle = req.query.shuffle === "1" || req.query.refresh === "1";

  try {
    const order = shuffle ? "RAND()" : "`sort_order` ASC, `id` ASC";
    const [rows] = await pool.query(
      `SELECT id, keyword, heat_text, tag
       FROM hot_search
       ORDER BY ${order}
       LIMIT 10`
    );

    return res.json({
      success: true,
      code: 0,
      message: "ok",
      data: { list: rows },
    });
  } catch (err) {
    console.error("[search/hot]", err);
    return res.status(500).json({
      success: false,
      code: 50000,
      message: "服务器繁忙，请稍后再试",
    });
  }
});

module.exports = router;
