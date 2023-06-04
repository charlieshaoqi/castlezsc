const speed = 5, interval = 16, number = 80
let pre = "CastleZSC牛逼！"


const params = location.search
if (params && params !== '') {
  let urlParam = new URLSearchParams(location.search)
  pre = decodeURI(urlParam.getAll("pre"))
}

window.callLemoToSetLabel = (tmpPre) => {
  pre = tmpPre
  let params = new URLSearchParams()
  params.append("pre", tmpPre)
  let newUrl = `${location.origin}${location.pathname}?${params.toString()}`
  return newUrl
}

let bodyH = document.body.clientHeight
let bodyW = document.body.clientWidth
const get = (length, symbol) => {
  let str = ''
  for (let index = 0; index < length; index++) {
    str += symbol
  }
  return str
}

const random = (num) => { return (Math.ceil(Math.random() * num)) }
const randomColor = () => { return `rgb(${random(255)},${random(255)},${random(255)})` }
const initDom = (e) => {
  e.style.right = `${-1 * random(bodyW)}px`
  e.style.whiteSpace = 'nowrap'
  e.style.fontSize = `${random(50)}px`
  e.style.position = 'fixed'
  e.style.color = randomColor()
  // e.style.backgroundColor=randomColor()
  e.style.top = `${random(bodyH)}px`
  e.innerHTML = `${pre}${get(random(10), `${pre}`)}`
}

let body = document.body
let elementList = []
body.setAttribute("style", "overflow:hidden;")
for (let index = 0; index < number; index++) {
  const tmp = document.createElement("div")
  initDom(tmp)
  body.appendChild(tmp)
  elementList.push(tmp)
}
const start = () => {
  elementList.forEach(e => {
    let originRight = parseInt(e.style.right.replace("px", ''))
    if (originRight > bodyW - 200) {
      initDom(e)
    } else {
      e.style.right = `${originRight + speed}px`
    }
  })
}

setInterval(() => {
  start()
}, interval)
