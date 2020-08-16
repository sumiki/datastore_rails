/* eslint no-console: 0 */
// Run this example by adding <%= javascript_pack_tag 'hello_vue' %> (and
// <%= stylesheet_pack_tag 'hello_vue' %> if you have styles in your component)
// to the head of your layout file,
// like app/views/layouts/application.html.erb.
// All it does is render <div>Hello Vue</div> at the bottom of the page.

import Vue from 'vue'
import { ApolloClient } from 'apollo-client'
import { HttpLink } from 'apollo-link-http'
import { setContext } from 'apollo-link-context';
import { InMemoryCache } from 'apollo-cache-inmemory'
import VueApollo from 'vue-apollo'

import Account from '../components/account.vue'
const httpLink = new HttpLink({
  uri: '/graphql',
})
const middlewareLink = setContext(() => ({
  headers: {
    'X-CSRF-TOKEN': document.querySelector('meta[name="csrf-token"]').getAttribute('content')
  }
}));
const apolloClient = new ApolloClient({
  link: middlewareLink.concat(httpLink),
  cache: new InMemoryCache(),
  connectToDevTools: true
})

Vue.use(VueApollo)

const apolloProvider = new VueApollo({
  defaultClient: apolloClient,
  defaultOptions: {
    $loadingKey: 'loading'
  }
})
document.addEventListener('DOMContentLoaded', () => {
  window.header = new Vue({
    el: "#dashboard",
    provide: apolloProvider.provide(),
    components: {
      Account
    },
    beforeMount () {
      const serverSideValues = JSON.parse(this.$el.getAttribute('server-side-values'));
      this.serverSideValues = serverSideValues
      this.accountId = serverSideValues['accounts'][0].id
    },
    data: function () {
      return {
        serverSideValues: {},
        accountId: null,
      }
    },
    methods: {
      handleAccountChange(e){
        e.preventDefault()
        this.accountId = e.target.value
      }
    }
  })
})
