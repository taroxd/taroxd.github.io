---
title: Epub 阅读器简单评测
---

<style>
.epub-reader-tooltip {
  position: relative;
  display: inline-block;
  font-size: 0.8em;
  vertical-align: super;
  font-weight: bold;
  color: #960014;
  cursor: pointer;
}

.epub-reader-tooltip .epub-reader-tooltiptext {
  visibility: hidden;
  width: 120px;
  background-color: #424242;
  color: #f2f2f2;
  text-align: center;
  border-radius: 6px;
  padding: 5px 0;
  opacity: 0;
  position: absolute;
  z-index: 1;
  transition: opacity, 0.3s;
  top: -4px;
  left: 150%; 
}

.epub-reader-tooltip .epub-reader-tooltiptext::after {
  content: " ";
  position: absolute;
  top: 50%;
  right: 100%;
  margin-top: -5px;
  border-width: 5px;
  border-style: solid;
  border-color: transparent #424242 transparent transparent;
}
</style>

<script>
;(function() {
    function toggle_tooltip() {
        for (const child of this.getElementsByClassName('epub-reader-tooltiptext')) {
            if (child.style.visibility === 'visible') {
                child.style.visibility = ''
                child.style.opacity = 0
            } else {
                child.style.visibility = 'visible'
                child.style.opacity = 1
            }
        }
    }

    window.addEventListener('load', function() {
        for (const tooltip of document.getElementsByClassName('epub-reader-tooltip')) {
            tooltip.addEventListener('click', toggle_tooltip.bind(tooltip))
        }
    })
})()
</script>

为了阅读一些排版精良的和排版糟糕的 epub，我试了一圈各种 epub 阅读器，结果并没有完全满意的。下面就我关心的几个方面展开评测，评测内容既有主观内容也有客观内容。

### 评测项目说明

* 【注音】形如“<ruby><rb>写作 A</rb><rp>(</rp><rt>读作 B</rt><rp>)</rp></ruby>”的格式支持。A 表示完全支持。
* 【注释】形如<span class="epub-reader-tooltip">注<span class="epub-reader-tooltiptext">注释内容</span></span>的格式支持。A 表示完全支持。
* 【CSS】对各种 CSS 样式的支持程度。对于排版优秀的书籍，CSS 支持良好时才能得到最佳的阅读体验。? 表示我没有仔细测试。
* 【排版】是否可以调整段首缩进、行距、段间距、页边距、字体样式、颜色等等。对于排版糟糕的书籍，该项能调整的范围越大才能得到更好的阅读体验。
* 【其他】不属于上述范围的部分。

## Windows

### Calibre (5.14.0)

* 【注音】A
* 【注释】A
* 【CSS】B?
* 【排版】A。可调整边距、颜色。可用户自定义字体。由于支持用户样式表，实质上支持一切排版调整。
* 【其他】支持大量其他电子书格式。初次打开一本书时较慢。

总评：A。

### Microsoft Edge (44.18362.267.0)

* 【注音】A
* 【注释】A
* 【CSS】A
* 【排版】C。可在预定义的几种字体中选择。可调整颜色。不可调整行距、边距、段首缩进等。
* 【其他】排版性能低下，容易卡顿；在 Chromium 版本推出之后，Edge 应该就不再支持 epub 了，且用且珍惜；不支持 Windows 8.1 及以前的版本。

总评：A。虽然调整排版的支持不佳，但是在 PC 环境下，排版的支持并没有那么重要。

## iOS

### Apple Books (iOS 12)

* 【注音】A
* 【注释】A
* 【CSS】A，但阅读器设置的字体常常会覆盖 CSS 中设置的字体。
* 【排版】C。可在预定义的几种字体中选择。可调整颜色。不可调整行距、边距、段首缩进等。
* 【其他】如果 epub 文件的语言元数据设置错误，那么可选择的字体会变成从对应的字体中选择，可能会非常难看；支持有声读物。

总评：A-。如果遇到制作糟糕的电子书，用 Apple Books 可能会很难受。

### Kybook 3 (v0.7.8)

* 【注音】C
* 【注释】A
* 【CSS】B?
* 【排版】A。可使用自定义的字体，可调整颜色、行距、边距、段首缩进等。支持自定义样式表，实质上支持一切排版调整。
* 【其他】不知为什么，登录功能无法使用，但这个和阅读没什么关系；支持大量其他电子书格式；不支持竖排（会变成横排）。

总评：A-。制作糟糕的电子书首选这个。

### 多看阅读 (5.5.0)

* 【注音】A
* 【注释】B（通过私有样式支持）
* 【CSS】C
* 【排版】B。可在预定义的几种字体中选择，但都不怎么好看。可调整颜色、行距、边距、段首缩进等。
* 【其他】与 iOS 版本不同，Android 版本支持自定义字体；不支持竖排（文字会消失？）；支持语音朗读。

总评：B。如果书籍专为多看阅读优化，那么可以使用。看日文书基本没法用（字体难看，而且不支持竖排）。

### Marvin (3.1.2)

* 【注音】A
* 【注释】C
* 【CSS】?
* 【排版】B。可在预定义的几种字体中选择，但其中没有中文字体。可调整颜色、行距、边距、段首缩进等。

总评：B-。没有中文字体，不建议使用。阅读英文电子书可以考虑一用。

### BookWalker (5.1.2)

虽然能看 epub，但中文支持非常糟糕，不予评测。

## Android

因为我自己不用安卓，所以以下内容都是从其他人口中得知。

### 多看阅读

与 iOS 版基本一致，但支持了自定义字体。

### 静读天下

* 【注音】A
* 【注释】A
* 【CSS】C
* 【排版】?

### 掌阅

无评测

### Lithium

无评测

## 总结

对于制作精美的 epub 电子书，建议按照发布者的推荐来选择阅读器。如果发布者没有推荐，建议使用 Microsoft Edge (Windows) / Apple Books (iOS) / 多看阅读 (Android)。

对于排版糟糕的 epub 电子书，建议使用 Calibre (Windows) / Kybook 3 (iOS) / 多看阅读、静读天下 (Android)。

关于我自己制作的电子书，不会用到过于精致的排版，但往往会使用注音和注释等功能。因此，建议使用 Microsoft Edge、Calibre（Windows）/ Apple Books (iOS) / 静读天下 (Android)。
