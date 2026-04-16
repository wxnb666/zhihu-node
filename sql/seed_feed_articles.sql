-- 推荐流示例：多篇文章 / 问题，列表摘要 + 详情正文（HTML）
-- 依赖：已存在 `user` 与 `feed_item` 表，且至少有一条用户。
-- 可重复执行：先按标题删除同名示例再插入（不删你自建的其他标题）。

SET NAMES utf8mb4;

DELETE FROM `feed_item` WHERE `title` IN (
  '这波人工智能浪潮怎么越来越像泡沫了？',
  '前端开发还有前途吗？一位全栈工程师的五年复盘',
  '程序员副业从 0 到稳定接单：我踩过的四个坑',
  '大模型落到业务里：我们团队这一年的工程化笔记',
  '美以冲突反复升级，普通投资者该关注什么？',
  'React 19 之后，还需要把 Redux 当作默认选项吗？',
  '写给应届生的简历：面试官真正扫的那几眼',
  '远程工作第三年：效率、孤独感与职业天花板',
  'TypeScript 严格模式开启后，十个高频报错怎么修？',
  '闭关四个月学 Rust：我留下的经验与遗憾',
  '如何评价 AI 编程助手对初中级岗位的影响？',
  '浏览器扩展开发在 2026 年还有搞头吗？',
  '从 0 搭建监控与告警：小团队的低成本实践'
);

INSERT INTO `feed_item` (`type`, `title`, `excerpt`, `content`, `author_id`, `agree_count`, `comment_count`, `favorite_count`, `like_count`)
SELECT 'article', '这波人工智能浪潮怎么越来越像泡沫了？',
  '从资本热度、落地场景和工程化成本看，这一轮和以往周期有相似也有不同……',
  CONCAT(
'<p>从资本热度、落地场景和工程化成本看，这一轮和以往周期有相似也有不同。讨论「泡沫」时，大家其实在说三件事：估值是否透支、需求是否真实、供给是否过剩。</p>',
'<h2>一、叙事与估值</h2>',
'<p>当融资节奏快于产品迭代，市场会用更短的耐心要求「可验证的里程碑」。这不代表技术路线错误，而是风险定价在重新校准。</p>',
'<h2>二、落地与单位经济模型</h2>',
'<p>真正拉开差距的往往是：推理成本、数据闭环、合规边界，以及能否把模型能力固化成可复用的工作流。能算账的团队，比只会讲故事的团队更抗周期。</p>',
'<h2>三、和以往周期的不同</h2>',
'<p>这一次基础设施更成熟、开源生态更活跃，同时也意味着竞争更同质化。结论不是「全是泡沫」或「没有泡沫」，而是分化会来得更快：能沉淀为产品能力的留下，纯概念更容易出清。</p>',
'<p>以上仅为示例长文，用于前端列表与详情页滚动、排版联调。</p>'
), `id`, 185, 84, 120, 6 FROM `user` ORDER BY `id` ASC LIMIT 1;

INSERT INTO `feed_item` (`type`, `title`, `excerpt`, `content`, `author_id`, `agree_count`, `comment_count`, `favorite_count`, `like_count`)
SELECT 'article', '前端开发还有前途吗？一位全栈工程师的五年复盘',
  '岗位在变，但「把复杂问题拆清楚并交付」的能力不会贬值。分享我这五年的转向与取舍……',
  CONCAT(
'<p>「还有前途吗」背后，往往是焦虑：框架更新太快、岗位边界变模糊、AI 工具能写样板代码。我的体感是：初级「堆页面」的红海在收缩，但工程化、性能、可访问性、协作与业务理解仍然稀缺。</p>',
'<h2>一、我如何定义「前端」</h2>',
'<p>不只是 UI，而是用户体验链路：加载、交互、错误恢复、数据一致性、观测与排障。能把这些串起来的人，仍然吃香。</p>',
'<h2>二、技能栈建议（个人向）</h2>',
'<p>TypeScript、构建与性能、组件设计、状态与数据获取、至少一种后端协作能力（接口契约、鉴权、缓存）。再补一点产品思维，会明显不一样。</p>',
'<h2>三、对 AI 的态度</h2>',
'<p>把它当加速器：生成草稿、补测试、查文档；但架构取舍、边界条件、线上事故复盘，仍然需要人负责。示例长文用于详情页联调。</p>'
), `id`, 942, 231, 310, 48 FROM `user` ORDER BY `id` ASC LIMIT 1;

INSERT INTO `feed_item` (`type`, `title`, `excerpt`, `content`, `author_id`, `agree_count`, `comment_count`, `favorite_count`, `like_count`)
SELECT 'article', '程序员副业从 0 到稳定接单：我踩过的四个坑',
  '定价、合同、交付边界和时间管理，每一项都能把副业拖垮。下面是血泪总结……',
  CONCAT(
'<p>副业最常见的失败不是技术，而是「把上班的习惯原封不动搬到私活里」：不敢报价、口头约定、需求无限膨胀、同时接太多单。</p>',
'<h2>坑一：不签合同或合同太虚</h2>',
'<p>至少写清范围、验收标准、修改次数、尾款节点。示例条款可找模板再本地化。</p>',
'<h2>坑二：按小时贱卖自己的注意力</h2>',
'<p>小需求可以尝试打包价；维护类再考虑周期计费。你要为自己的切换成本买单。</p>',
'<h2>坑三：把「能做完」当成「该接」</h2>',
'<p>学会拒绝：需求含混、对方反复压价、沟通成本异常高的项目，长期不划算。</p>',
'<h2>坑四：牺牲睡眠硬扛</h2>',
'<p>副业是马拉松。留固定不可用时间段，反而更容易持续赚钱。本文为示例长文。</p>'
), `id`, 516, 178, 89, 22 FROM `user` ORDER BY `id` ASC LIMIT 1;

INSERT INTO `feed_item` (`type`, `title`, `excerpt`, `content`, `author_id`, `agree_count`, `comment_count`, `favorite_count`, `like_count`)
SELECT 'article', '大模型落到业务里：我们团队这一年的工程化笔记',
  '提示词、RAG、评测与回归、成本监控……从 Demo 到稳定服务，中间隔着一整条流水线。',
  CONCAT(
'<p>很多团队第一个月能做出惊艳 Demo，第三个月开始被「回归」「幻觉」「成本」教做人。我们这一年最大的收获，是把「可观测」和「可回滚」放在第一位。</p>',
'<h2>1. 评测集比灵感更重要</h2>',
'<p>固定一批真实业务问题，版本迭代必须跑分；人工抽检作为补充而不是唯一依据。</p>',
'<h2>2. RAG 不是万能插头</h2>',
'<p>切片策略、元数据、重排、拒答与引用展示，都会影响信任感。用户更在意「为什么这样回答」。</p>',
'<h2>3. 成本曲线要画出来</h2>',
'<p>峰值 QPS、token、缓存命中、批处理窗口，任何一项都可能让账单失控。本文为示例长文用于详情页测试。</p>'
), `id`, 1203, 356, 402, 71 FROM `user` ORDER BY `id` ASC LIMIT 1;

INSERT INTO `feed_item` (`type`, `title`, `excerpt`, `content`, `author_id`, `agree_count`, `comment_count`, `favorite_count`, `like_count`)
SELECT 'article', '美以冲突反复升级，普通投资者该关注什么？',
  '地缘风险会传导到油价、航运与风险偏好，但比「预测战争」更重要的是仓位与流动性纪律……',
  CONCAT(
'<p>市场短期定价的是不确定性与风险溢价。对普通人来说，与其押注单一叙事，不如检查：现金流是否安全、是否过度集中、是否有应急资金。</p>',
'<h2>能源与航运链条</h2>',
'<p>油价波动往往最先被交易；相关行业的盈利弹性差异很大，需要区分传导路径。</p>',
'<h2>权益资产的波动</h2>',
'<p>风险偏好下降时，高估值板块更敏感；但这不是投资建议，只是示例文章结构用于前端展示。</p>',
'<p>本文为联调用示例长文，不构成任何投资意见。</p>'
), `id`, 428, 112, 55, 14 FROM `user` ORDER BY `id` ASC LIMIT 1;

INSERT INTO `feed_item` (`type`, `title`, `excerpt`, `content`, `author_id`, `agree_count`, `comment_count`, `favorite_count`, `like_count`)
SELECT 'article', 'React 19 之后，还需要把 Redux 当作默认选项吗？',
  'Server Components、新的调度与并发特性，会改变状态管理的边界。聊聊我现在的默认组合……',
  CONCAT(
'<p>Redux 依然强大，尤其在中大型团队需要可预测的数据流与调试工具链时。但「默认上 Redux」的时代确实过去了：很多场景用 URL、服务端状态、局部状态就能解决。</p>',
'<h2>选择框架前先画数据流</h2>',
'<p>谁是源真相？是否需要时间旅行调试？是否需要中间件生态？答案会自然收敛。</p>',
'<h2>组合优于宗教</h2>',
'<p>Zustand、Jotai、TanStack Query 各有甜点区；关键是约束团队写法，而不是堆库。本文为示例长文。</p>'
), `id`, 688, 199, 140, 33 FROM `user` ORDER BY `id` ASC LIMIT 1;

INSERT INTO `feed_item` (`type`, `title`, `excerpt`, `content`, `author_id`, `agree_count`, `comment_count`, `favorite_count`, `like_count`)
SELECT 'article', '写给应届生的简历：面试官真正扫的那几眼',
  '项目写满三页不如写清一个问题：你解决了什么、怎么验证有效、你负责哪一段闭环……',
  CONCAT(
'<p>简历不是自传，是「证据链」。面试官前几秒看的是：学校/实习标签、关键词匹配、项目是否可追问。</p>',
'<h2>项目描述用 STAR 的变体</h2>',
'<p>背景一句话、目标量化、手段要点、结果用数字或链接证明（GitHub、演示视频）。</p>',
'<h2>少写形容词，多写动词</h2>',
'<p>「熟悉」不如「用 X 做过 Y，遇到 Z 问题用 W 解决」。示例长文用于详情页排版测试。</p>'
), `id`, 2105, 412, 620, 105 FROM `user` ORDER BY `id` ASC LIMIT 1;

INSERT INTO `feed_item` (`type`, `title`, `excerpt`, `content`, `author_id`, `agree_count`, `comment_count`, `favorite_count`, `like_count`)
SELECT 'article', '远程工作第三年：效率、孤独感与职业天花板',
  '异步沟通、文档文化、可见性焦虑，远程不是「在家办公」四个字能概括的……',
  CONCAT(
'<p>远程第三年，我最大的变化是：把「可被看见」从临场反应，改成可检索的产出。周报、设计文档、决策记录，都是职业资产。</p>',
'<h2>效率：时间块与深度工作</h2>',
'<p>会议压缩到固定窗口；深度工作放在精力最好的时段；避免「随时在线」导致碎片化。</p>',
'<h2>孤独感：主动建立弱连接</h2>',
'<p>同行咖啡聊天、社区贡献、线下活动，都是情绪缓冲。本文为示例长文。</p>',
'<h2>天花板：用影响力半径衡量成长</h2>',
'<p>从完成任务到推动他人完成，再到定义问题，这是另一条晋升曲线。</p>'
), `id`, 367, 98, 76, 19 FROM `user` ORDER BY `id` ASC LIMIT 1;

INSERT INTO `feed_item` (`type`, `title`, `excerpt`, `content`, `author_id`, `agree_count`, `comment_count`, `favorite_count`, `like_count`)
SELECT 'article', 'TypeScript 严格模式开启后，十个高频报错怎么修？',
  'strict、noImplicitAny、严格空值检查一开，老项目像被照妖镜照了一遍。下面是「改法清单」……',
  CONCAT(
'<p>严格模式的价值在于把隐性假设显性化。痛苦期通常 2～6 周，取决于项目规模与类型覆盖程度。</p>',
'<ol>',
'<li><code>any</code> 泛滥：先收口边界类型，再逐步内推。</li>',
'<li>可能为 <code>undefined</code>：用可选链、窄化、或显式默认值。</li>',
'<li>第三方库缺类型：补 <code>declaration</code> 或封装适配层。</li>',
'</ol>',
'<p>其余条目省略为示例结构；正文足够长用于详情页滚动测试。</p>'
), `id`, 1555, 287, 401, 62 FROM `user` ORDER BY `id` ASC LIMIT 1;

INSERT INTO `feed_item` (`type`, `title`, `excerpt`, `content`, `author_id`, `agree_count`, `comment_count`, `favorite_count`, `like_count`)
SELECT 'article', '闭关四个月学 Rust：我留下的经验与遗憾',
  '所有权、生命周期、错误处理模型一旦过关，写系统软件会很爽；但学习曲线也确实陡……',
  CONCAT(
'<p>Rust 让我重新理解「编译期能兜住多少类内存与并发错误」。四个月里我做过 CLI、小型网络服务、以及用 WASM 做浏览器侧实验。</p>',
'<h2>经验</h2>',
'<p>跟官方 Book + 小项目交替推进；遇到生命周期地狱先画图，再考虑是否过度抽象。</p>',
'<h2>遗憾</h2>',
'<p>生态里某些领域库不如其他语言成熟；团队若全是新手，落地成本要评估。本文为示例长文。</p>'
), `id`, 821, 156, 203, 41 FROM `user` ORDER BY `id` ASC LIMIT 1;

INSERT INTO `feed_item` (`type`, `title`, `excerpt`, `content`, `author_id`, `agree_count`, `comment_count`, `favorite_count`, `like_count`)
SELECT 'question', '如何评价 AI 编程助手对初中级岗位的影响？',
  '从招聘侧与学习者两侧看，「会写代码」的门槛在降，但「能交付」的门槛其实在升……',
  CONCAT(
'<p>这个问题没有单一答案。短期看，样板代码、脚手架、简单 CRUD 的边际价值下降；中期看，评审、测试、架构与业务拆解更重要。</p>',
'<p>对初中级同学：把 AI 当「副驾驶」，把代码审查、单测、可观测性当作基本功。示例问题正文用于详情/回答区联调。</p>'
), `id`, 3401, 890, 1200, 210 FROM `user` ORDER BY `id` ASC LIMIT 1;

INSERT INTO `feed_item` (`type`, `title`, `excerpt`, `content`, `author_id`, `agree_count`, `comment_count`, `favorite_count`, `like_count`)
SELECT 'question', '浏览器扩展开发在 2026 年还有搞头吗？',
  'Manifest V3、隐私政策与商店审核都在变，但垂直场景的工具需求仍在……',
  CONCAT(
'<p>扩展开发的「搞头」更多来自细分痛点：效率工具、研究助手、企业内部插件。通用大类早已红海。</p>',
'<p>技术侧要关注权限最小化、审核材料准备、以及跨浏览器适配成本。本文为示例长文。</p>'
), `id`, 266, 74, 38, 9 FROM `user` ORDER BY `id` ASC LIMIT 1;

INSERT INTO `feed_item` (`type`, `title`, `excerpt`, `content`, `author_id`, `agree_count`, `comment_count`, `favorite_count`, `like_count`)
SELECT 'article', '从 0 搭建监控与告警：小团队的低成本实践',
  '日志、指标、链路不必一次上全，关键是先回答「线上出问题我五分钟能定位吗」……',
  CONCAT(
'<p>小团队最怕「监控很重、没人看」。我的路径是：先统一日志格式与 request id，再挑 5 个核心业务指标，最后才上追踪采样。</p>',
'<h2>告警阈值</h2>',
'<p>宁可少报，也要避免告警疲劳；每条告警要有 runbook 链接或处理人。示例长文用于前端详情页测试。</p>'
), `id`, 445, 121, 67, 15 FROM `user` ORDER BY `id` ASC LIMIT 1;
