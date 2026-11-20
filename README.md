# html

开门网页（静态页，Cloudflare Workers 部署：https://opendoor.jzdd327.workers.dev）

## 页面

| 页面 | 地址 | 作用 |
| --- | --- | --- |
| `index.html` | `/` 或 `/index.html` | 手动开门：点哪个门开哪个 |
| `autoOpen.html` | `/autoOpen.html` | 自动开门：打开页面、拿到门禁列表后，自动请求打开名字里带「单元」的那扇门 |

两个页面主体、样式、token 读取完全一致，共用同目录的 `token.txt`；只有「是否自动开门」这一处逻辑不同。

## 换 token 只要改 token.txt

页面里不再写死 token，启动时用 `fetch('token.txt')` 读取同目录的 `token.txt`：

1. 打开 `token.txt`，把里面 `app:...` 那一行改成新 token（保留 `#` 开头的注释行不影响）；
2. 重新部署（把 `token.txt` 一起上传，它和两个 html 必须在同一目录）；
3. 手机/浏览器刷新页面即可，html 不用动。

`index.html` 的 `CONFIG.TOKEN` 现在只是兜底值（默认空），`CONFIG.TOKEN_FILE` 是文件名。
页面顶部若提示「读取 token.txt 失败」，就是 token.txt 没上传、路径不对，或者被当成网页返回了。

## autoOpen.html 的自动开门规则

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
