import Vue from 'vue'
Vue.use(Vuex)

import Vuex from 'vuex'
export const store = new Vuex.Store({
  state: {
    pages: [],
    user: {
      address: ''
    },
    currentPage: '',
    letters: []
  }
  // ,
  // getters: {
  //   color({pages}) {
  //     return pages
  //   }
  // },
  // mutations: {
  //   setColor(state, payload) {
  //     state.color = payload
  //   }
  // },
  // actions: {
  //   setColor({commit}, payload) {
  //     commit('setColor', payload)
  //   }
  // }
})
