import Vue from 'vue'
import Router from 'vue-router'
// import Dashboard from '@/components/Dashboard'
import Signup from '@/components/Signup'
import FanLetters from '@/components/FanLetters'

Vue.use(Router)

export default new Router({
  routes: [
    {
      path: '/',
      name: 'FanLetters',
      component: FanLetters
    },
    // {
    //   path: '/',
    //   name: 'dashboard',
    //   component: Dashboard
    // },
    {
      path: '/signup',
      name: 'signup',
      component: Signup
    }
  ]
})
