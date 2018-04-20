<template>
  <div id="app">
    <nav id="lang">
      <ul>
        <li><a href="#" v-on:click.prevent="lang('EN')">EN</a></li>
        <li><a href="#" v-on:click.prevent="lang('中文')">中文</a></li>
        <li><a href="#" v-on:click.prevent="lang('日本')">日本</a></li>
        <li><a href="#" v-on:click.prevent="lang('POR')">POR</a></li>
        <li><a href="#" v-on:click.prevent="lang('ไทย')">ไทย</a></li>
        <li><a href="#" v-on:click.prevent="lang('한국어')">한국어</a></li>
        <li><a href="#" v-on:click.prevent="lang('FR')">FR</a></li>
        <li><a href="#" v-on:click.prevent="lang('РУ')">РУ</a></li>
        <li><a href="#" v-on:click.prevent="lang('ES')">ES</a></li>
      </ul>
    </nav>

    <div id="sns">
      <a href="">TW</a>
      <a href="">Link</a>
    </div>
    <div id="header">
      <img id="logo" src="./assets/love-letter.png">
      <h3 class="subtitle">{{ $t("message.subtitle") }}</h3>
      <h3 class="subtitle2">{{ $t("message.subtitle2") }}</h3>
      <h1 id="title">CryptoLoveLetter</h1>
    </div>
    <div id="list">

      <div v-for="item, i in pages" class="box" v-on:click="selectPage(item)">
        <div class="Profile-avatar" >
            <img class="ProfileAvatar-image"  style="width:73px;height:73px" v-bind:src="'https://twitter.com/'+ item + '/profile_image?size=bigger'"/>
          </div>
        {{ item }}
      </div>
      <div class="box" @click="newPage()">
        <img src="http://via.placeholder.com/73x73">
        <span> NEW </span>
      </div>

      <!-- <div class="box selected" @click="selectPage(1)">
        <img src="http://via.placeholder.com/75x75">
        <span>지드래곤</span>
      </div>
      <div class="box" @click="selectPage(2)">
        <img src="http://via.placeholder.com/75x75">
        <span> 가상화폐걸 </span>
      </div>
      <div class="box" @click="selectPage(3)">
        <img src="http://via.placeholder.com/75x75">
        <span> 티아라 </span>
      </div>
      <div class="box" @click="newPage()">
        <img src="http://via.placeholder.com/75x75">
        <span> NEW </span>
      </div> -->
    </div>
    <router-view></router-view>
  </div>
</template>

<script>
import Vue from 'vue'
import VueI18n from 'vue-i18n'
import EventBus from './event-bus'

const data = require('./message.json')
// 언어설정
// var EventBus = new Vue()

Vue.use(VueI18n)
const i18n = new VueI18n({
  locale: '한국어', // 기본언어는 ko로 유지하지만 브라우저 언어를 체크해서 변경
  messages: data
})
// const { mapGetters, mapActions, Store } = Vuex

export default {
  name: 'app',
  i18n: i18n,
  data () {
    return {
      items: [
        'IBGDRGN',
        'iya9005'
      ]
    }
  },
  computed: {
    pages () {
      return this.$store.state.pages
    }
  },
  methods: {
    selectPage (twitterId) {
      EventBus.$emit('selectPage', twitterId)
    },
    newPage () {
      EventBus.$emit('newPage', '')
    },
    lang (lang) {
      this.$i18n.locale = lang
    }
  },
  created () {
    console.log(window.web3.eth.accounts[0])
    window.web3.eth.getBalance(window.web3.eth.accounts[0], 'latest', function (err, result) {
      if (err) {
        console.log('err=' + err)
      } else {
        console.log('balance=' + result)
      }
    })
  }
}
</script>

<style>

.box {
    display: inline-block;
    width: 75px;
    cursor: pointer;
    border: 2px solid #eee;
    padding: 1px;
}

.box:hover {
    border: 2px solid blue;
}
.box.selected {
    border: 2px solid red;
}
div#header {
    height: 68px;
    /* top: -53px; */
    margin-top: -26px;
}
h3.subtitle {
    float: left;
    padding-left: 11px;
}

h3.subtitle2 {
    float: right;
    padding-right: 11px;
}
#title {
  width: 200px;
  margin-left: -100px;
  position: absolute;
  top: 24px;
  left: 50%;
  font-size: 23px;
}
img#logo {
  width: 200px;
  margin-left: -98px;
  position: absolute;
  top: 0px;
  left: 50%;
}
nav#lang {
  position: absolute;left: 0px;
  top: 0px;
  display: none;
}
div#sns {
  position: fixed;
    right: 0px;
    top: 65px;
    height: 20px;
    padding: 18px;
}
div#google_translate_element {
    left: 11px;
    position: absolute;
    top: -15px;
}
button {
    background-color: #102cf6;
    color: #f0f0f0;
    font-size: 18px;
    border-radius: 5px;
    margin-top: 7px;
    padding: 6px;
    padding-left: 20px;
    padding-right: 20px;
    font-weight: bolder;
}
nav#lang ul {
    list-style: none;
    padding-left: 15px;
}
div#sns a {
    display: block;
}
nav#lang li {
    display: inline-block;
}.box {
    display: inline-block;
    width: 75px;
    vertical-align: top;
    overflow: hidden;

}
#app {
  font-family: 'Avenir', Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
  margin-top: 60px;
}
</style>
