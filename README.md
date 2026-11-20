# html

开门网页（静态页；CloudBase 国内站已部署，Cloudflare Workers 仍保留：https://opendoor.jzdd327.workers.dev）

## 页面

| 页面 | 地址 | 作用 |
| --- | --- | --- |
| `index.html` | `/` 或 `/index.html` | 手动开门：点哪个门开哪个 |
| `auto.html` | `/auto.html` | 自动开门：打开页面、拿到门禁列表后，自动请求打开名字里带「单元」的那扇门 |

两个页面主体、样式、token 读取完全一致，共用同目录的 `token.txt`；只有「是否自动开门」这一处逻辑不同。

## token 从哪来：手填优先，留空才读 token.txt

两个页面的 `<script>` 顶部的 `CONFIG` 里有 `TOKEN` 变量，规则是**手填优先**：

| `CONFIG.TOKEN` | 行为 |
| --- | --- |
| `''`（默认） | 启动时 `fetch('token.txt')`，读同目录的 token.txt |
| 填了内容 | 直接用这个值，**完全不请求 token.txt**（临时换号、临时部署很方便） |

日常改 token 的推荐做法（不用动 HTML）：

1. 打开 `token.txt`，把里面 `app:...` 那一行改成新 token（`#` 开头的注释行不影响）；
2. 重新部署（`token.txt` 要和两个 html 在同一目录）；
3. 手机/浏览器刷新页面即可。

想临时手填就用另一种方式：把 `CONFIG.TOKEN: ''` 改成 `CONFIG.TOKEN: 'app:xxxxxxxx'`，再部署。
填错了（有空格之类）页面顶部会提示「CONFIG.TOKEN 里填的 token 用不了」，改回 `''` 就恢复读 token.txt。
`CONFIG.TOKEN_FILE` 是文件名（默认 `token.txt`）；页面顶部若提示「读取 token.txt 失败」，就是文件没上传、路径不对，或者被当成网页返回了。

## auto.html 的自动开门规则

- 打开页面并**成功拿到门禁列表**后，自动打开第一扇名字含「单元」的门，用户不用再点；
- 列表里没有含「单元」的门时，不请求开门，只在顶部提示「请手动点击」；
- 点右上角刷新 / 点「重新加载」也会自动开门一次（想再开一次门就点刷新）；
- 从别的页面切回来触发的静默刷新**不会**自动开门，避免每次切回来都把门打开；
- 切换小区不会自动开门，选完小区后手动点门（如需自动，可自行改成也传 `autoOpen: true`）。

## 部署到 CloudBase 国内站（已接入）

- 环境 ID：`inland-mandrill-d4ffh2w8c1643875`（体验版，ap-shanghai，到期 2027-05-20）
- 默认域名：https://inland-mandrill-d4ffh2w8c1643875-1256043088.tcloudbaseapp.com
- 重新部署（改完 token 或页面后）：

  ```sh
  tcb login                 # 首次需要，扫码/授权
  ./deploy.sh               # 默认部署到上面的环境
  ./deploy.sh <envId>       # 或指定其他环境
  ```

- 注意：CloudBase **默认测试域名**每次从书签/地址栏直接访问，都会先弹「风险提醒」页（3 秒倒计时 + 确定访问），点完才进页面；这是平台对 `*.tcloudbaseapp.com` 的限制，绑定**已备案的自定义域名**后才会消失。

## 注意

token.txt 是纯静态文件，知道网址的人也能直接打开它，别把它放到公开仓库里长期留存。
