<template>
  <div class="fixed bottom-0 inset-x-0 px-4 pb-4 sm:inset-0 sm:flex sm:items-center sm:justify-center">
    <!--
      Background overlay, show/hide based on modal state.

      Entering: "ease-out duration-300"
        From: "opacity-0"
        To: "opacity-100"
      Leaving: "ease-in duration-200"
        From: "opacity-100"
        To: "opacity-0"
    -->
    <div class="fixed inset-0 transition-opacity">
      <div class="absolute inset-0 bg-gray-500 opacity-75"></div>
    </div>

    <!--
      Modal panel, show/hide based on modal state.

      Entering: "ease-out duration-300"
        From: "opacity-0 translate-y-4 sm:translate-y-0 sm:scale-95"
        To: "opacity-100 translate-y-0 sm:scale-100"
      Leaving: "ease-in duration-200"
        From: "opacity-100 translate-y-0 sm:scale-100"
        To: "opacity-0 translate-y-4 sm:translate-y-0 sm:scale-95"
    -->
    <div v-if="!!!flagSubmitConfirmation" class="bg-white rounded-lg overflow-hidden shadow-xl transform transition-all sm:max-w-lg sm:w-full" role="dialog" aria-modal="true" aria-labelledby="modal-headline">
      <div class="bg-white px-4 pt-5 pb-4 sm:p-6 sm:pb-4">
        <div class="sm:flex sm:items-start">
          <div class="mt-3 text-center sm:mt-0 sm:ml-4 sm:text-left">
            <h3 class="leading-6 font-medium text-gray-900" id="modal-headline">
              Selling
            </h3>
            <div class="mt-2">
              <div class="m-3">
                <label class="block text-sm leading-5 text-gray-500">Ticket Symbol</label>
                <input type="text" disabled :value="holding.tickerSymbol" class="p-1 border" name="ticket_symbol" placeholder="SPY" >
              </div>
              <div class="m-3">
                <label class="block text-sm leading-5 text-gray-500">Purchase Price</label>
                <input type="text" disabled :value="aggDetail.price" class="p-1 border" name="name" placeholder="999.99" >
              </div>
              <div class="m-3">
                <label class="block text-sm leading-5 text-gray-500">Purchase Date</label>
                <input type="text" disabled :value="aggDetail.purchaseDate" class="p-1 border" name="name" placeholder="999.99" >
              </div>

              <div class="m-3">
                <label class="block text-sm leading-5 text-gray-500">Selling Date</label>
                <input type="text" v-model="formSellingDate" class="p-1 border" name="name" >
                <div :class="errorFieldClass" v-for="errorText in errorSellingDate">
                  <div v-text="errorText"></div>
                </div>
              </div>
              <div class="m-3">
                <label class="block text-sm leading-5 text-gray-500">Selling Price</label>
                <input type="text" :value="formSellingPrice" class="p-1 border" name="name" >
              </div>
              <div class="m-3">
                <label class="block text-sm leading-5 text-gray-500">Selling Count</label>
                <input type="text" :value="formSellingCount" class="p-1 border" name="name" placeholder="999.99" >
              </div>
            </div>
          </div>
        </div>
      </div>
      <div class="bg-gray-50 px-4 py-3 sm:px-6 sm:flex sm:flex-row-reverse">
          <span class="flex w-full rounded-md shadow-sm sm:ml-3 sm:w-auto">
            <button @click="handleSubmit" type="button" class="inline-flex justify-center w-full rounded-md border border-transparent px-4 py-2 bg-red-600 text-base leading-6 font-medium text-white shadow-sm hover:bg-red-500 focus:outline-none focus:border-red-700 focus:shadow-outline-red transition ease-in-out duration-150 sm:text-sm sm:leading-5">
              Sell
            </button>
          </span>
        <span class="mt-3 flex w-full rounded-md shadow-sm sm:mt-0 sm:w-auto">
            <button @click="closeSellingModal" type="button" class="inline-flex justify-center w-full rounded-md border border-gray-300 px-4 py-2 bg-white text-base leading-6 font-medium text-gray-700 shadow-sm hover:text-gray-500 focus:outline-none focus:border-blue-300 focus:shadow-outline-blue transition ease-in-out duration-150 sm:text-sm sm:leading-5">
              Cancel
            </button>
          </span>
      </div>
    </div>
    <div v-else class="bg-white rounded-lg overflow-hidden shadow-xl transform transition-all sm:max-w-lg sm:w-full" role="dialog" aria-modal="true" aria-labelledby="modal-headline">
      <div class="bg-white px-4 pt-5 pb-4 sm:p-6 sm:pb-4">
        <div class="sm:flex sm:items-start">
          <div class="mt-3 text-center sm:mt-0 sm:ml-4 sm:text-left">
            <h3 class="leading-6 font-medium text-gray-900" id="modal-headline">
              Successfully Craeted
            </h3>
            <div class="mt-2">
              <p class="text-sm leading-5 text-gray-500">
              </p>
            </div>
          </div>
        </div>
        <div class="bg-gray-50 px-4 py-3 sm:px-6 sm:flex sm:flex-row-reverse">
            <span class="flex w-full rounded-md shadow-sm sm:ml-3 sm:w-auto">
              <button @click="closeSellingModal" type="button" class="inline-flex justify-center w-full rounded-md border border-transparent px-4 py-2 bg-red-600 text-base leading-6 font-medium text-white shadow-sm hover:bg-red-500 focus:outline-none focus:border-red-700 focus:shadow-outline-red transition ease-in-out duration-150 sm:text-sm sm:leading-5">
                OK
              </button>
            </span>
        </div>
      </div>
    </div>
  </div>
</template>
<script>
import { CREATE_HOLDING_MUTATION } from '../constants/graphql'
export default {
  props: [
      'accountId',
      'holding',
      'aggDetail'
  ],
  data () {
    return {
      flagSubmitConfirmation: false,
      formSellingPrice: 0.0,
      formSellingCount: 0,
      formSellingDate: '',
      errorSellingDate: [],
    }
  },
  mounted: function(){
    this.formSellingCount = this.aggDetail.count
    this.formSellingPrice = this.aggDetail.price

    let today = new Date();
    let dd = String(today.getDate()).padStart(2, '0');
    let mm = String(today.getMonth() + 1).padStart(2, '0'); //January is 0!
    let yyyy = today.getFullYear();
    this.formSellingDate = yyyy + '/' + mm + '/' + dd;
  },
  methods: {
    closeSellingModal(e){
      this.$emit('closeSellingModal', e)
    },
    handleSubmit(e){
      e.preventDefault()

    },
  },
}
</script>
