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
    <div class="bg-white rounded-lg overflow-hidden shadow-xl transform transition-all sm:max-w-lg sm:w-full" role="dialog" aria-modal="true" aria-labelledby="modal-headline">
      <div class="bg-white px-4 pt-5 pb-4 sm:p-6 sm:pb-4">
        <div class="sm:flex sm:items-start">
          <div class="mt-3 text-center sm:mt-0 sm:ml-4 sm:text-left">
            <h3 class="leading-6 font-medium text-gray-900" id="modal-headline">
              Create Holding
            </h3>
            <div class="mt-2">
              <div class="m-3">
                <label class="block text-sm leading-5 text-gray-500">Ticket Symbol</label>
                <input type="text" v-model="formTickerSymbol" class="p-1 border" name="ticket_symbol" placeholder="SPY" >
                <div :class="errorFieldClass" v-for="errorText in errorTickerSymbol">
                  <div v-text="errorText"></div>
                </div>
              </div>
              <div class="m-3">
                <label class="block text-sm leading-5 text-gray-500">Name</label>
                <input type="text" v-model="formName" class="p-1 border" name="name" placeholder="SP500" >
                <div :class="errorFieldClass" v-for="errorText in errorName">
                  <div v-text="errorText"></div>
                </div>
              </div>
              <div class="m-3">
                <label class="block text-sm leading-5 text-gray-500">Purchase Price</label>
                <input type="text" v-model="formPurchasePrice" class="p-1 border" name="name" placeholder="999.99" >
                <div :class="errorFieldClass" v-for="errorText in errorPurchasePrice">
                  <div v-text="errorText"></div>
                </div>
              </div>
              <div class="m-3">
                <label class="block text-sm leading-5 text-gray-500">Purchase Count</label>
                <input type="text" v-model="formPurchaseCount" class="p-1 border" name="name" placeholder="10" >
                <div :class="errorFieldClass" v-for="errorText in errorPurchaseCount">
                  <div v-text="errorText"></div>
                </div>
              </div>
              <div class="m-3">
                <label class="block text-sm leading-5 text-gray-500">Purchase Date</label>
                <input type="text" v-model="formPurchaseDate" class="p-1 border" name="name" placeholder="2020/07/01" >
                <div :class="errorFieldClass" v-for="errorText in errorPurchaseDate">
                  <div v-text="errorText"></div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
      <div class="bg-gray-50 px-4 py-3 sm:px-6 sm:flex sm:flex-row-reverse">
          <span class="flex w-full rounded-md shadow-sm sm:ml-3 sm:w-auto">
            <button @click="handleSubmit" type="button" class="inline-flex justify-center w-full rounded-md border border-transparent px-4 py-2 bg-red-600 text-base leading-6 font-medium text-white shadow-sm hover:bg-red-500 focus:outline-none focus:border-red-700 focus:shadow-outline-red transition ease-in-out duration-150 sm:text-sm sm:leading-5">
              Create
            </button>
          </span>
        <span class="mt-3 flex w-full rounded-md shadow-sm sm:mt-0 sm:w-auto">
            <button @click="closeHoldingModal" type="button" class="inline-flex justify-center w-full rounded-md border border-gray-300 px-4 py-2 bg-white text-base leading-6 font-medium text-gray-700 shadow-sm hover:text-gray-500 focus:outline-none focus:border-blue-300 focus:shadow-outline-blue transition ease-in-out duration-150 sm:text-sm sm:leading-5">
              Cancel
            </button>
          </span>
      </div>
    </div>
  </div>
</template>
<script>
  import { CREATE_HOLDING_MUTATION } from '../constants/graphql'
  export default {
    props: ['accountId'],
    data () {
      return {
        formTickerSymbol: 'SPY',
        formName: 'SP500',
        formPurchaseCount: '1',
        formPurchasePrice: '1.01',
        formPurchaseDate: '2020/07/01',
        errorTickerSymbol: [],
        errorName: [],
        errorPurchaseCount: [],
        errorPurchasePrice: [],
        errorPurchaseDate: [],
        errorFieldClass: 'text-red-600 font-small',
        createHolding: {},
      }
    },
    methods: {
      closeHoldingModal(e){
        this.$emit('closeHoldingModal', e)
      },
      validateAll(){
        let resValidateTicketSymbol = this.validateTickerSymbol()
        let resValidateName = this.validateName()
        let resValidatePurchaseCount = this.validatePurchaseCount()
        let resValidatePurchasePrice = this.validatePurchasePrice()
        return resValidateTicketSymbol &&
          resValidateName &&
          resValidatePurchaseCount &&
          resValidatePurchasePrice
      },
      validateTickerSymbol(){
        let errorTickerSymbol = []
        if(this.formTickerSymbol === ''){
          errorTickerSymbol.push('Please enter TicketSymbol')
        }
        this.errorTickerSymbol = errorTickerSymbol
        return errorTickerSymbol.length === 0
      },
      validateName(){
        let errorName = []
        if(this.formName === ''){
          errorName.push('Please enter Name')
        }
        this.errorName = errorName
        return errorName.length === 0
      },
      validatePurchaseCount(){
        let errorPurchaseCount = []
        if(this.formPurchaseCount === ''){
          errorPurchaseCount.push('Please enter Purchase Count')
        }
        this.errorPurchaseCount = errorPurchaseCount
        return errorPurchaseCount.length === 0
      },
      validatePurchasePrice(){
        let errorPurchasePrice = []
        if(this.formPurchasePrice === ''){
          errorPurchasePrice.push('Please enter Purchase Price')
        }
        this.errorPurchasePrice = errorPurchasePrice
        return errorPurchasePrice.length === 0
      },
      handleSubmit(e){
        e.preventDefault()

        if(!this.validateAll()) return

        // We save the user input in case of an error
        const newTag = this.newTag
        // We clear it early to give the UI a snappy feel
        this.newTag = ''
        // Call to the graphql mutation
        this.$apollo.mutate({
          // Query
          mutation: CREATE_HOLDING_MUTATION,
          // Parameters
          variables: {
            accountId: parseInt(this.accountId),
            tickerSymbol: this.formTickerSymbol,
            name: this.formName,
            purchaseCount: parseInt(this.formPurchaseCount),
            purchasePrice: parseFloat(this.formPurchasePrice),
            purchaseDate: this.formPurchaseDate,
          },
        }).then((data) => {
          // Result
          console.log(data.data.createHolding)
        }).catch((error) => {
          // Error
          console.log('--error--')
          console.log(error)
          // We restore the initial user input
        })
      }
    },
  }
</script>
