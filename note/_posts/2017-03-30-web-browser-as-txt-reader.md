---
title: 用浏览器阅读 txt 电子书
---

```html
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title></title>
<style>
#txt {
  margin: auto;
  width: 80%;
  font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Helvetica, Arial, sans-serif, "Apple Color Emoji", "Segoe UI Emoji", "Segoe UI Symbol";
  font-size: 20px;
}

#txt p {
  white-space: pre-wrap;
  text-indent: 2em;
}
</style>
<script>
window.addEventListener('load', () => {
  txt.innerHTML = txt.innerHTML.replace(/.+/g, "<p>$&</p>")
})
</script>
</head>
<body>
<div id="txt">
将 txt 电子书的内容放在这里，并将这段代码保存成 html 文件。
用浏览器打开该 html 文件，即可开始阅读电子书。阅读体验相对于文本编辑器（如 nodepad）会有一定的提升。
txt 电子书中，段首无需空格。如果电子书中段首已经空格，可以将 css 中的 "text-indent: 2em;" 删去，以防止额外的段首缩进。
可以自由地更改 CSS 代码以获得最佳的阅读效果。
</div>
</body>
</html>
```

### 效果示例：

<script>
var post = document.currentScript.parentNode
var code = post.getElementsByClassName('highlight')[0].innerText
var text = code.match(/<div id="txt">([^]+)<\/div>/)[1]
var html = text.replace(/.+/g, "<p>$&</p>")
var css = code.match(/<style>([^]+)<\/style>/)[1]
var styleElem = document.createElement('style')
if (styleElem.styleSheet) {
  styleElem.styleSheet.cssText = css
} else {
  styleElem.appendChild(document.createTextNode(css))
}
var head = document.getElementsByTagName('head')[0]
head.appendChild(styleElem)

document.write('<div id="txt">', html, "</div>")
</script>
