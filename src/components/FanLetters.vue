<template>
  <div class="hello">



    <div class="left" v-bind:class="{ new_page: new_page}">
        <div id="new_page">
          <h1 v-if="new_page === true" class="hp_last">가장 먼저 페이지를 만드세요</h1>
          <h1 v-if="new_page === false" class="hp_last">편지 받는 사람</h1>
          <label>1. 트위터 주소</label>  <br>
          https://twitter.com/<b>{{twitter}}</b>
          <input v-if="new_page === true"  id="twitter" width="250" v-validate="'required'" v-model="twitter" placeholder="여기를 수정해보세요"><br><br>
          <label  v-if="new_page === true">2. 트위터 이미지 확인하기 </label>
          <div v-if="new_page === true" class="Profile-avatar" >
            <img v-if="twitter != ''" class="ProfileAvatar-image"  style="width:60px;height:60px" v-bind:src="'https://twitter.com/'+ twitter + '/profile_image?size=bigger'"/>
            <img v-if="twitter === ''" class="ProfileAvatar-image" style="width:60px;height:60px" src="../assets/profile.png" />
          </div>
        </div>
        <div id="my_letter" v-if="new_page === false">
          <!-- <span class="twitter" v-if="twitter != ''" >@{{twitter}}</span> -->
          <h1 class="hp_last">편지쓰기</h1>
          <label>1. 편지 색상</label> <slider-picker v-model="color" />
          <span class="info">글씨 색은 편지 색상의 보색을 선택됩니다.</span><br>
          <br>

          <label>2. 닉네임 </label> <input v-validate="'required'" v-model="author" placeholder="여기를 수정해보세요"><br>
          <br>
          <!-- 5. 편지 위치 <input v-validate="'required'" v-model="position" placeholder="여기를 수정해보세요"><br> -->
          <!-- 7. 이미지
            <div class="file-upload-form">
                <input type="file" @change="previewImage" accept="image/*">
            </div>
            <div class="image-preview" v-if="imageData.length > 0">
                <img class="preview" :src="imageData">
            </div> -->
          <br>
          <label>3. 편지크기</label>
              <vue-slider v-model="letter_width" v-bind="option"></vue-slider>

          <br>
          <label>3. 내용</label>
          <!-- <input v-validate="'required'" v-model="message" placeholder="여기를 수정해보세요"> -->
          <VueEmoji @input="onInput" @change="onInput" :value="message" />

          {{ message.length }} 글자수<br>
          <span class="info">이모티콘 사용이 가능합니다.</span><br>
          <br>
          <!-- <label>4. 링크 (옵션)</label><br>
          https://twitter.com/<input v-validate="'required|link'"  v-model="link" placeholder="여기를 수정해보세요"><br>
          <span class="info">편지를 클릭하면 이동될 페이지입니다. 안전을 위해서 트위터 주소만 가능합니다. (먼저 트윗을 올리고 트윗주소가 만들어지면 여기에 넣어주세요.)
          </span>
           -->
          <!-- <label>4. 링크 (옵션)</label><br>
          https://twitter.com/<input v-validate="'required|link'"  v-model="link" placeholder="여기를 수정해보세요"><br>
          <span class="info">편지를 클릭하면 이동될 페이지입니다. 안전을 위해서 트위터 주소만 가능합니다. (먼저 트윗을 올리고 트윗주소가 만들어지면 여기에 넣어주세요.)
          </span> -->
          <br>

        </div>
        <div id="sum_price" >
          <h1 v-if="new_page === true" class="hp_last">새로운 페이지 만드는 비용</h1>
          <h1 v-if="new_page === false" class="hp_last">편지 쓰는 비용</h1>
          <!-- <h1 class="hp_last" >가격</h1> -->
          <div class="text_right">
            편지(위치) : 2 * 0.02 eth<br>
            편지(크기) : 10 * 0.001 eth<br>
            편지(글자) : 25 * 0.01 eth<br>
            첫페이지 개설 할인 : - 0.02 eth<br>
            <hr>
            합계 : 0.3 eth<br>
          </div>

          <button v-if="new_page === true" @click="makePage" name="makePage">결제 및 페이지 만들기</button><br>
          <button v-if="new_page === false" @click="writeLetter" name="writeLetter">결제 및 편지보내기</button><br>
            <span class="info">!주의! 우리는 여기의 내용을 트위터 주인에게 우편을 보내지 않습니다.
              다만, 사람들을 사랑의 글을 쓰고 공유하면 어쩌면 주인이 한번을 읽을 수 있다고 생각합니다.
              그때 우리들의 사랑을 한번에 볼 수 있다고 생각합니다. 당신의 관심과 사랑을 보여주세요.
            </span>

        </div>

        <div id="help">
          <h1 class="hp_last" >도움말</h1>
          <p>
            <ul>
              <li><b>준비:</b> <a href="https://metamask.io/" target="_blank">MetaMask 설치</a> </li>
              <li><b>무료:</b> Rinkeby Test 네트워크 선택</li>
              <li><b>유료:</b> Main 네트워크 선택</li>
            </ul>
          </p>
        </div>
    </div>

    <div id="letters" v-if="new_page === false">
      <!-- <span class="area">[ 영역 3 ]</span>
      <div id="letters_1">
        <span class="area">[ 영역 2 ]</span>

        <div id="letters_2">
          <span class="area">[ 영역 1 ]</span> -->
            <div class="Profile-avatar left" style="padding-top: 35px;">
                <a class="ProfileAvatar-container u-block js-tooltip profile-picture"
                  v-bind:href="'https://twitter.com/'+ twitter"
                  target="_blank">
                  <img v-if="twitter != ''" class="ProfileAvatar-image"
                   v-bind:src="'https://twitter.com/'+ twitter + '/profile_image?size=bigger'"/>
                  <img v-if="twitter === ''" class="ProfileAvatar-image"  src="../assets/profile.png" />
                <span class="twitter" v-if="twitter != ''" >받는 사람: @{{twitter}}</span>
                </a>
            </div>
            <div  v-for="item in items">
                <div class="preview" v-bind:style="{ 'background-color': item.color.hex+'',
                 width: item.width + 'px', height: item.height + 'px' }">
                 <div>
                   <i class="fas fa-chevron-up"></i>
                   <span class="score">{{item.score}}</span>
                   <i class="fas fa-chevron-down"></i>
                 </div>
                  <p v-bind:style="{color: item.complementColor}">
                    <b v-bind:style="{color: item.complementColor}">{{ item.author }}</b><br>
                    {{ item.message }}
                    <button>투표하기
                   <i class="fas fa-thumbs-up"></i>
                    </button><br>

                  </p>
                </div>
            </div>
            <!--
            <div id="mydiv" v-bind:style="{left: left+ 'px', top: top + 'px'}">
              <div id="mydivheader">
                <div class="preview" v-bind:style="{ 'background-color': color.hex+'',
                 width: width2 + 'px', height: height2 + 'px' }">
                  <p v-bind:style="{color: complementColor}">
                    <b v-bind:style="{color: complementColor}">{{ author }}</b><br>
                    {{ message }}
                  </p>
                </div>
              </div>
            </div> -->
<!--
        <span class="area buttom">[ 영역 1 ]</span>
        </div>
        <span class="area buttom">[ 영역 2 ]</span>
      </div>
      <span class="area buttom">[ 영역 3 ]</span> -->
    </div>

  </div>
</template>

<script>
// http://vuejs.kr/vue/vee-validate/2017/04/01/using-vee-validate/
// https://xiaokaike.github.io/vue-color/
// import Vue from 'vue'
import { Slider } from 'vue-color'
// import { fabric } from 'fabric'
import EventBus from '../event-bus'
import VueEmoji from 'emoji-vue'
// var EventBus = new Vue()
import vueSlider from 'vue-slider-component'

export default {
  name: 'FanLetters',
  components: {
    'vueSlider': vueSlider,
    'slider-picker': Slider,
    'VueEmoji': VueEmoji
  },
  data () {
    return {
      items: [
        {
          author: 'GD바라기2',
          message: '😳오빠 군생활 잘 하세용 기다릴게요~',
          complementColor: '#000000',
          color: {
            hex: '#ffffff'
          },
          score: 100
        },
        {
          author: 'GD바라기2',
          message: '😳오빠 군생활 잘 하세용 기다릴게요~',
          complementColor: '#000000',
          color: {
            hex: '#ffffff'
          },
          score: 85
        },
        {
          author: 'GD바라기2',
          message: '😳오빠 군생활 잘 하세용 기다릴게요~',
          complementColor: '#000000',
          color: {
            hex: '#ffffff'
          },
          score: 33
        }
      ],
      twitter: 'IBGDRGN',
      new_page: false,
      letter_width: 100,
      option: {
        min: 50,
        max: 200,
        interval: 5
      },
      new_page_colors: '#194d33',
      author: 'GD바라기',
      current_page_name: '지드래곤',
      message: '😳오빠 군생활 잘 하세용 기다릴게요~',
      color: {
        hex: '#ffffff'
      },
      page_idx: 1,
      color_num: 1,
      smart_contract: '0x0b7c205151570bafa199aa53949fbf3e90d6e62e',
      left: 650,
      top: 480,
      width: 100,
      height: 100,
      now: new Date(Date.now()).toLocaleString(),
      link: 'http://', // 클릭시 링크
      position: '15, 100, 100, 100', // x, y, width, height
      msg: 'Welcome to Your Vue.js App',
      receiveText: '',
      imageData: '', // we will store base64 format of image in this string
      abi: [
        {
          'anonymous': false,
          'inputs': [
            {
              'indexed': true,
              'name': 'idx',
              'type': 'uint256'
            },
            {
              'indexed': false,
              'name': 'from',
              'type': 'address'
            },
            {
              'indexed': false,
              'name': 'value',
              'type': 'uint256'
            }
          ],
          'name': 'AddPageValue',
          'type': 'event'
        },
        {
          'constant': false,
          'inputs': [
            {
              'name': '_idx',
              'type': 'uint256'
            }
          ],
          'name': 'addPageValue',
          'outputs': [],
          'payable': true,
          'stateMutability': 'payable',
          'type': 'function'
        },
        {
          'constant': false,
          'inputs': [
            {
              'name': '_manager',
              'type': 'address'
            }
          ],
          'name': 'changeManager',
          'outputs': [],
          'payable': false,
          'stateMutability': 'nonpayable',
          'type': 'function'
        },
        {
          'constant': false,
          'inputs': [
            {
              'name': '_twitterId',
              'type': 'string'
            }
          ],
          'name': 'newPage',
          'outputs': [
            {
              'name': 'idx',
              'type': 'uint256'
            }
          ],
          'payable': false,
          'stateMutability': 'nonpayable',
          'type': 'function'
        },
        {
          'constant': false,
          'inputs': [
            {
              'name': '_idx',
              'type': 'uint256'
            }
          ],
          'name': 'sendPageEther',
          'outputs': [],
          'payable': false,
          'stateMutability': 'nonpayable',
          'type': 'function'
        },
        {
          'constant': false,
          'inputs': [
            {
              'name': '_price',
              'type': 'uint256'
            }
          ],
          'name': 'setCharacterPrice',
          'outputs': [],
          'payable': false,
          'stateMutability': 'nonpayable',
          'type': 'function'
        },
        {
          'constant': false,
          'inputs': [
            {
              'name': '_page_idx',
              'type': 'uint256'
            },
            {
              'name': '_letter_idx',
              'type': 'uint256'
            },
            {
              'name': '_key',
              'type': 'uint256'
            },
            {
              'name': '_value',
              'type': 'uint256'
            }
          ],
          'name': 'setLetterAttribute',
          'outputs': [],
          'payable': false,
          'stateMutability': 'nonpayable',
          'type': 'function'
        },
        {
          'constant': false,
          'inputs': [
            {
              'name': '_page_idx',
              'type': 'uint256'
            },
            {
              'name': '_letter_idx',
              'type': 'uint256'
            },
            {
              'name': '_score',
              'type': 'uint256'
            }
          ],
          'name': 'setLetterScore',
          'outputs': [],
          'payable': false,
          'stateMutability': 'nonpayable',
          'type': 'function'
        },
        {
          'constant': false,
          'inputs': [
            {
              'name': '_idx',
              'type': 'uint256'
            },
            {
              'name': '_receiver',
              'type': 'address'
            }
          ],
          'name': 'setPageReceiver',
          'outputs': [],
          'payable': false,
          'stateMutability': 'nonpayable',
          'type': 'function'
        },
        {
          'anonymous': false,
          'inputs': [
            {
              'indexed': true,
              'name': 'page_idx',
              'type': 'uint256'
            },
            {
              'indexed': true,
              'name': 'letter_idx',
              'type': 'uint256'
            },
            {
              'indexed': true,
              'name': 'owner',
              'type': 'address'
            },
            {
              'indexed': false,
              'name': 'contents',
              'type': 'string'
            }
          ],
          'name': 'Publish',
          'type': 'event'
        },
        {
          'anonymous': false,
          'inputs': [
            {
              'indexed': false,
              'name': 'page_idx',
              'type': 'uint256'
            },
            {
              'indexed': false,
              'name': 'letter_idx',
              'type': 'uint256'
            },
            {
              'indexed': false,
              'name': 'score',
              'type': 'uint256'
            }
          ],
          'name': 'SetLetterScore',
          'type': 'event'
        },
        {
          'anonymous': false,
          'inputs': [
            {
              'indexed': false,
              'name': 'price',
              'type': 'uint256'
            }
          ],
          'name': 'SetCharacterPrice',
          'type': 'event'
        },
        {
          'constant': false,
          'inputs': [
            {
              'name': '_page_idx',
              'type': 'uint256'
            },
            {
              'name': '_contents',
              'type': 'string'
            }
          ],
          'name': 'writeLetter',
          'outputs': [
            {
              'name': 'idx',
              'type': 'uint256'
            }
          ],
          'payable': true,
          'stateMutability': 'payable',
          'type': 'function'
        },
        {
          'anonymous': false,
          'inputs': [
            {
              'indexed': false,
              'name': 'page_idx',
              'type': 'uint256'
            },
            {
              'indexed': false,
              'name': 'letter_idx',
              'type': 'uint256'
            },
            {
              'indexed': false,
              'name': 'key',
              'type': 'uint256'
            },
            {
              'indexed': false,
              'name': 'value',
              'type': 'uint256'
            }
          ],
          'name': 'SetLetterAttribute',
          'type': 'event'
        },
        {
          'inputs': [],
          'payable': false,
          'stateMutability': 'nonpayable',
          'type': 'constructor'
        },
        {
          'constant': true,
          'inputs': [
            {
              'name': '_page_idx',
              'type': 'uint256'
            },
            {
              'name': '_letter_idx',
              'type': 'uint256'
            }
          ],
          'name': 'getLetterContents',
          'outputs': [
            {
              'name': '',
              'type': 'string'
            }
          ],
          'payable': false,
          'stateMutability': 'view',
          'type': 'function'
        },
        {
          'constant': true,
          'inputs': [
            {
              'name': '_page_idx',
              'type': 'uint256'
            }
          ],
          'name': 'getLettersLength',
          'outputs': [
            {
              'name': '',
              'type': 'uint256'
            }
          ],
          'payable': false,
          'stateMutability': 'view',
          'type': 'function'
        },
        {
          'constant': true,
          'inputs': [],
          'name': 'getPagesLength',
          'outputs': [
            {
              'name': '',
              'type': 'uint256'
            }
          ],
          'payable': false,
          'stateMutability': 'view',
          'type': 'function'
        },
        {
          'constant': true,
          'inputs': [
            {
              'name': '_index',
              'type': 'uint256'
            }
          ],
          'name': 'getPageTwitterId',
          'outputs': [
            {
              'name': '',
              'type': 'string'
            }
          ],
          'payable': false,
          'stateMutability': 'view',
          'type': 'function'
        },
        {
          'constant': true,
          'inputs': [],
          'name': 'manager',
          'outputs': [
            {
              'name': '',
              'type': 'address'
            }
          ],
          'payable': false,
          'stateMutability': 'view',
          'type': 'function'
        },
        {
          'constant': true,
          'inputs': [
            {
              'name': '',
              'type': 'uint256'
            }
          ],
          'name': 'pages',
          'outputs': [
            {
              'name': 'twitterId',
              'type': 'string'
            },
            {
              'name': 'receiver',
              'type': 'address'
            },
            {
              'name': 'balance',
              'type': 'uint256'
            }
          ],
          'payable': false,
          'stateMutability': 'view',
          'type': 'function'
        }
      ]
    }
  },
  computed: {
    width2: function () {
      return this.letter_width
    },
    height2: function () {
      return this.letter_width
    },
    complementColor: function () {
      return this.invertColor(this.color.hex)
    },
    sc () {
      var cryptoloveletterContract = window.web3.eth.contract(this.abi)
      var lc = cryptoloveletterContract.at(this.smart_contract)
      return lc
    }
  },
  created () {
    EventBus.$on('selectPage', this.onReceiveSelectPage)
    EventBus.$on('newPage', this.onReceiveNewPage)
    EventBus.$on('message', this.onReceive)
    this.getPages()
    // // src/worker.js
    // const Aragon = require('@aragon/client')
    // // Initialise the app
    // const app = new Aragon()
    // console.log(app)
  },
  // 캔버스 만들기
  mounted () {

    // 편지지 넣기
    // canvas.add(new fabric.Circle({ radius: 30, fill: '#f55', top: 100, left: 100 }))
    // canvas.item(0).set({
    //   borderColor: 'red',
    //   cornerColor: 'green',
    //   cornerSize: 6,
    //   transparentCorners: false
    // })
    // // canvas.setActiveObject(canvas.item(0))
    //
    // var textbox = new fabric.Textbox('군생활 잘 하세용', {
    //   left: 50,
    //   top: 50,
    //   width: 150,
    //   fontSize: 20
    // })
    // canvas.add(textbox).setActiveObject(textbox)
    // this.__canvases.push(canvas)
  },
  methods: {
    invertColor (hexTripletColor) {
      var color = hexTripletColor
      color = color.substring(1) // remove #
      color = parseInt(color, 16)// convert to integer
      color = 0xFFFFFF ^ color // invert three bytes
      color = color.toString(16) // convert to hex
      color = ('000000' + color).slice(-6) // pad with leading zeros
      color = '#' + color // prepend #
      return color
    },
    makePaper () {
      console.log(this.color)
    },
    onReceiveSelectPage (text) {
      this.receiveText = text
      this.twitter = text
      this.new_page = false
      console.log('onReceiveSelectPage' + text)
    },
    onReceiveNewPage (text) {
      this.receiveText = text
      this.new_page = true
      console.log('onReceiveNewPage' + text)
      this.twitter = ''
      // document.getElementById('twitter').focus()
    },
    onReceive (text) {
      this.receiveText = text
      console.log('onReceive' + text)
    },
    // 내용일 입력이 될때
    onInput: function (event) {
      this.message = event.data
        // event.data contains the value of the textarea
    },
    // 이미지 미리보기
    previewImage: function (event) {
      // Reference to the DOM input element
      var input = event.target
      // Ensure that you have a file before attempting to read it
      if (input.files && input.files[0]) {
        // create a new FileReader to read this image and convert to base64 format
        var reader = new FileReader()
        // Define a callback function to run, when FileReader finishes its job
        reader.onload = (e) => {
          // Note: arrow function used here, so that "this.imageData" refers to the imageData of Vue component
          // Read image as base64 and set to imageData
          this.imageData = e.target.result
        }
        // Start the reader job - read file as a data url (base64 format)
        reader.readAsDataURL(input.files[0])
      }
    },
    // 편지쓰기
    writeLetter: function () {
      // uint _x, uint _y, uint _width, uint _height
      //         , uint _page_idx
      //         , uint _color
      //         , string _nickname
      //         , string _contents
      //         , string _link
      // //         ) payable returns (uint idx) {
      // var obj = [this.top, this.left, this.width, this.height,
      //   this._page_idx, this._color, this.author, this.smart_contract,
      //   this.message, this.link]
      // 1, 2, 3, 4, 0, 1, "11", "22", "33"
      /*
      uint _x, uint _y, uint _width, uint _height
        , uint _page_idx
        , uint _color
        , string _nickname
        , string _contents
        , string _link
      */
      console.log(this.sc)
      var dd = {from: window.web3.eth.accounts[0], value: 10000000000000000, gas: 2100000, gasPrice: 21000000000}
      this.sc.buy.sendTransaction(this.top, this.left, this.width, this.height,
        this.page_idx, this.color_num, this._color, this.author, this.message, this.link, dd, function (err, res) {
          console.log(err)
          console.log(res)
        })
      // console.log(window.web3.eth.accounts[0])
      // window.web3.eth.getBalance(window.web3.eth.accounts[0], 'latest', function (err, result) {
      //   if (err) {
      //     console.log('err=' + err)
      //   } else {
      //     console.log('balance=' + result)
      //   }
      // })
    },
    makePage: function () {
      if (this.twitter === '') {
        alert('트위터 아이디가 지정되지 않음')
        return false
      }
      this.sc.newPage.call(this.twitter, {from: window.web3.eth.accounts[0], value: 10000000000000000, gas: 2100000, gasPrice: 21000000000}, function (err, res) {
        console.log(err)
        console.log(res)
      })
    },
    getPageLength: function () {
      this.sc.getPagesLength.call({}, {},
        function (err, res) {
          console.log('res', res)
          console.log('err', err)
        })
    },
    getPage: function (index) {
      console.log('getPage')
      this.sc.pages.call(0, {},
        function (err, res) {
          console.log('res', res)
          console.log('err', err)
        })
    },
    getPages: function () {
      var self = this
      self.sc.getPagesLength.call({}, {},
        function (err, res) {
          console.log('1res', res.c[0])
          if (!err) {
            for (var i = res.c[0] - 1; i >= 0; i--) {
              self.sc.pages.call(i, {},
                function (err, res) {
                  console.log('2res', res)
                  console.log('2err', err)
                  self.$store.state.pages.push(res[0])
                })
            }
          }
          console.log('1res', res)
          console.log('1err', err)
        })
    }
  }
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
label {
    color: #000;
    font-weight: bold;
    font-size: 1.1em;
}
h1.hp_1 {
    margin-bottom: 0;
}
h1.hp_m {
    margin-bottom: 0;
    margin-top: 0;

}
img.ProfileAvatar-image {
    background: #fff;
    border: 5px solid #777;
    border-radius: 50%;
    height: 73px;
    position: relative;
    width: 73px;
}
h1.hp_last {
    margin-top: 0;
}
.left > div {
    display: inline-block;
    width: 250px;
    text-align: left;
    border-top: 6px dotted gray;
    margin-bottom: 30px;
    padding-left: 10px;
    margin-right: 10px;
    padding-top: 35px;    float: left;
}
.file-upload-form, .image-preview {
    font-family: "Helvetica Neue",Helvetica,Arial,sans-serif;
    padding: 20px;
}
img.preview {
    width: 200px;
    background-color: white;
    border: 1px solid #DDD;
    padding: 5px;
}
img.pic {
    width: 100px;
}
canvas#c {
    position: absolute;
    /* float: left; */
    width: 1200px;
    left: 0px;
    height: 1500px;
}
div#my_letter {

    float: left;
    display: inline-block;
    width: 250px;
    vertical-align: top;
    text-align: left;
    padding-left: 10px;
}
span.info {
    color: #666;
    font-size: 14px;
}
div#help {
    display: inline-block;
    width: 250px;
    vertical-align: top;
    text-align: left;
    padding-left: 20px;
}
.left{
  width: 290px;
  vertical-align: top;
  display: inline-block;
}
.preview{
  overflow: hidden;
  border: 1px solid darkred;
  padding: 0;
  margin: 0;
    position: relative;
}
span.twitter {
    display: block;
    font-size: 22px;
    color: #000;
    font-weight: bold;
}
h1.to {
    text-align: left;
    padding-left: 24px;
    font-weight: bold;
    text-decoration: underline;
}
p {
    text-align: left;
    padding: 10px;
    margin-left: 30px;
}


li {
    width: 100%;
}.hello {
    padding-top: 28px;
}
span.area {
    display: block;
    color: #b4b4b4;
}
span.area.buttom {
    margin-top: 250px;
}
#letters_2{
  border: 5px solid #ececec;
  border-radius: 40px;
    margin-top: -5px;
  width: 500px;
  height: 500px;
  margin-left: auto;
  margin-right: auto;
  background-color: #fff;
}
#letters_1{
  border: 5px solid #ececec;
  border-radius: 40px;
    margin-top: -5px;
  width: 900px;
  height: 900px;
  margin-left: auto;
  margin-right: auto;
  background-color: #f3fbff;
}
#letters{
  display: inline-block;
  border: 5px solid #f2f2f2;
  border-radius: 40px;
  width: 1100px;
  height: 1500px;
  margin-left: auto;
  margin-right: auto;
  background-color: #fdffe4;
}
.vc-slider {
    width: 200px;
}
h1, h2 {
  font-weight: normal;
}
ul {
  list-style-type: none;
  padding: 0;
}
li {
  display: inline-block;
  margin: 0 10px;
}
a {
  color: #42b983;
}
input {
    height: 25px;
}
.left.new_page {
    width: 1300px;
    margin-left: auto;
    margin-right: auto;
}

.left.new_page > div {
    width: 30% !important;
}
span.score {
    position: absolute;
    left: 8px;
    top: 49px;
}
.mydiv, #mydiv {
    position: absolute;
    z-index: 9;
    background-color: #f1f1f1;
    border: 1px solid #d3d3d3;
    text-align: center;
}
i.fas.fa-chevron-up {
    position: absolute;
    left: 10px;
    top: 10px;
}
i.fas.fa-chevron-down {
    position: absolute;
    left: 10px;
    bottom: 10px;
}
.mydivheader, #mydivheader {
    /* padding: 10px; */
    cursor: move;
    z-index: 10;
    /* background-color: #2196F3; */
    /* color: #fff; */
}


</style>
