const express = require("express");
const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");
const pool = require("../db");

const router = express.Router();

const JWT_SECRET = process.env.JWT_SECRET || "zhihu-dev-secret-change-me";
const JWT_EXPIRES = process.env.JWT_EXPIRES_IN || "7d";

/** 中国大陆手机号（与常见前端校验一致） */
function isValidCnMobile(phone) {
  return /^1[3-9]\d{9}$/.test(phone);
}

function normalizePhone(body) {
  const raw = body.phone ?? body.phone_number ?? body.mobile;
  if (raw === undefined || raw === null) return "";
  return String(raw).trim();
}

/**
 * POST /api/login
 * body: { phone | phone_number, password }
 */
router.post("/login", async (req, res) => {
  const phone = normalizePhone(req.body);
  const password = req.body.password;

  if (!phone) {
    return res.status(400).json({
      success: false,
      code: 40001,
      message: "请输入手机号",
    });
  }

  if (password === undefined || password === null || String(password).length === 0) {
    return res.status(400).json({
      success: false,
      code: 40002,
      message: "请输入密码",
    });
  }

  if (!isValidCnMobile(phone)) {
    return res.status(400).json({
      success: false,
      code: 40003,
      message: "手机号格式不正确",
    });
  }

  try {
    const [rows] = await pool.query(
      "SELECT `id`, `phone`, `password` FROM `user` WHERE `phone` = ? LIMIT 1",
      [phone]
    );

    const user = rows[0];
    if (!user) {
      return res.status(401).json({
        success: false,
        code: 40101,
        message: "手机号或密码错误",
      });
    }

    const stored = user.password;
    const plain = String(password);
    let match = false;

    if (typeof stored === "string" && stored.startsWith("$2")) {
      match = await bcrypt.compare(plain, stored);
    } else if (process.env.NODE_ENV !== "production" && typeof stored === "string") {
      // 仅开发环境：兼容未做哈希的测试数据（生产环境请勿写入明文密码）
      match = plain === stored;
    }

    if (!match) {
      return res.status(401).json({
        success: false,
        code: 40101,
        message: "手机号或密码错误",
      });
    }

    const token = jwt.sign({ sub: user.id, phone: user.phone }, JWT_SECRET, {
      expiresIn: JWT_EXPIRES,
    });

    return res.json({
      success: true,
      code: 0,
      message: "登录成功",
      data: {
        token,
        token_type: "Bearer",
        expires_in: JWT_EXPIRES,
        user: {
          id: user.id,
          phone: user.phone,
        },
      },
    });
  } catch (err) {
    console.error("[login]", err);
    return res.status(500).json({
      success: false,
      code: 50000,
      message: "服务器繁忙，请稍后再试",
    });
  }
});

module.exports = router;
