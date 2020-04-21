// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import css from "../css/app.css"

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import dependencies
//
import "phoenix_html"

import { Socket } from "phoenix"
import LiveSocket from "phoenix_live_view"

let Hooks = {}
Hooks.ContentEditable = {
  mounted() {
    this.el.addEventListener("input", e => {
      this.pushEvent('render_post', {
        value: e.target.innerText,
      })
    })
  },
  beforeUpdate() {
    this.cursorPos = getCurrentCursorPosition('markdown-container')
  },
  updated() {
    setCursorPos(this.cursorPos, this.el)
  },
}

// https://stackoverflow.com/a/41034697
function getCurrentCursorPosition(parentId) {
  var selection = window.getSelection(),
    charCount = -1,
    node

  if (selection.focusNode) {
    if (isChildOf(selection.focusNode, parentId)) {
      node = selection.focusNode
      charCount = selection.focusOffset

      while (node) {
        if (node.id === parentId) {
          break
        }

        if (node.previousSibling) {
          node = node.previousSibling
          charCount += node.textContent.length
        } else {
          node = node.parentNode
          if (node === null) {
            break
          }
        }
      }
    }
  }

  return charCount
}

function setCursorPos(chars, el) {
  if (chars >= 0) {
    var selection = window.getSelection()

    var range = createRange(el, { count: chars })

    if (range) {
      range.collapse(false)
      selection.removeAllRanges()
      selection.addRange(range)
    }
  }
}

function isChildOf(node, parentId) {
  while (node !== null) {
    if (node.id === parentId) {
      return true
    }
    node = node.parentNode
  }

  return false
}

function createRange(node, chars, range) {
  if (!range) {
    range = document.createRange()
    range.selectNode(node)
    range.setStart(node, 1)
  }

  if (chars.count === 0) {
    range.setEnd(node, chars.count)
  } else if (node && chars.count > 0) {
    if (node.nodeType === Node.TEXT_NODE) {
      if (node.textContent.length < chars.count) {
        chars.count -= node.textContent.length
      } else {
        range.setEnd(node, chars.count)
        chars.count = 0
      }
    } else {
      for (var lp = 0; lp < node.childNodes.length; lp++) {
        range = createRange(node.childNodes[lp], chars, range)

        if (chars.count === 0) {
          break
        }
      }
    }
  }
  return range
}

let liveSocket = new LiveSocket("/live", Socket, {hooks: Hooks})
liveSocket.connect()

// Import local files
//
// Local files can be imported directly using relative paths, for example:
// import socket from "./socket"
