<template>
  Yes
  {{contractResult}}
  {{contractResultJSONData}}
  <!-- <div id="demo">
    <vue-metamask 
      ref="metamask"
      userMessage="msg" 
      @onComplete="onComplete"
      :initConnect="true"
    >
    </vue-metamask>
  </div> -->
  <Card style="width: 25rem; margin-bottom: 2em; margin-top: 2em; text-align: center;">
    <template #title>
      Login
    </template>
    <template #content>
      <div class="field col-12 md:col-4">
        <div class="p-inputgroup">
          <span class="p-inputgroup-addon">
            <i class="pi pi-user"></i>
          </span>
          <span class="p-float-label">
            <InputText id="username" type="text" v-model="username" />
            <label for="username">Username</label>
          </span>
        </div>
      </div>
      <div class="field col-12 md:col-4" style="margin-top:1rem;">
        <div class="p-inputgroup">
          <span class="p-inputgroup-addon">
            <i class="pi pi-lock"></i>
          </span>
          <span class="p-float-label">
            <Password v-model="pswdValue">
              <template #header>
                <h6>Pick a password</h6>
              </template>
              <template #footer>
                <Divider /> 
                <p class="mt-2">Suggestions</p>
                <ul class="pl-2 ml-2 mt-0" style="line-height: 1.5">
                  <li>At least one lowercase</li>
                  <li>At least one uppercase</li>
                  <li>At least one numeric</li>
                  <li>Minimum 8 characters</li>
                </ul>
              </template>
            </Password>
            <label for="password">Password</label>
          </span>
        </div>
      </div>
      <Button label="Login" style="margin-top:1rem;"/>
      <Button label="Connect" @click="connect" style="margin-top:1rem;"/>
    </template>
  </Card>
  <Toast position="bottom-right" group="br" />
</template>

<script>
// import VueMetamask from 'vue-metamask';
import loginData from '../data/loginData.json'
import Web3 from 'web3'
export default {
  components: {
    // VueMetamask,
  },
  data() {
    return {
      username: null,
      pswdValue: null,
      msg: "This is demo net work",
      combinedUserList: null,
      actualmetaMaskAddress: null,
      actualuserType: null,
      contractResult: null,
      contractResultJSONData: null,
    }
  },
  created(){
    console.log("loginData",loginData,window.ethereum);
    let ethereum = window.ethereum;
    if (ethereum) {
      ethereum.request({ method: 'eth_requestAccounts' })
        .then(() => {
          this.connected = true;
          this.hitContract();
        });
    }
  },
  methods:{
    hitContract(){
      let web3 = new Web3("ws://localhost:7545");
      web3.eth.getAccounts().then(e => { 
      web3.eth.defaultAccount = e[0]
      console.log("A: " + e[0]);
      console.log("block",web3.eth.getBlock(1));
      console.log("getBlockNumber",web3.eth.getBlockNumber());
      console.log("getBlockTransactionCount",web3.eth.getBlockTransactionCount());
      console.log("getUncle",web3.eth.getUncle(2, 0));
      // getTransaction
      web3.eth.getCode(e[0])
        .then(console.log);
      })
      // let contractAddress;
      // console.log("getCreates",web3.eth.getCreates());
      // web3.eth.getBlock(4)
      //   .then((obj) => {
      //     console.log("obj",obj,obj.transactions[0]);
      //     web3.eth.getTransaction(obj.transactions[0])
      //       .then((innerObj) => {
      //         console.log("innerObj",innerObj,innerObj.to);
      //         contractAddress = innerObj.to;
      //       })

      //   });
      let contractAddress = '0x897cA1e9f7503444D30F84354e40ae09d864b22F';
      let abi = JSON.parse(`
      [
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "num1",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "num2",
				"type": "uint256"
			}
		],
		"name": "add",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "num1",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "num2",
				"type": "uint256"
			}
		],
		"name": "divide",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "string",
				"name": "arg",
				"type": "string"
			}
		],
		"name": "jsonData",
		"outputs": [
			{
				"internalType": "string",
				"name": "",
				"type": "string"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "num1",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "num2",
				"type": "uint256"
			}
		],
		"name": "multiply",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "registeredUsers",
		"outputs": [
			{
				"internalType": "bytes",
				"name": "",
				"type": "bytes"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "num1",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "num2",
				"type": "uint256"
			}
		],
		"name": "subtract",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	}
]
`);


      let contract = new web3.eth.Contract(abi, contractAddress, web3.eth.defaultAccount);
      contract.methods.add(10,20).call()
        .then(result => this.contractResult = result);
      contract.methods.jsonData().call()
        .then(result => this.contractResultJSONData = JSON.parse(JSON.stringify(result)));
      contract.methods.jsonData().call()
        .then((result) => {
          this.contractResultJSONData = JSON.parse(JSON.stringify(result));
          console.log("this.contractResultJSONData", JSON.parse(this.contractResultJSONData), typeof this.contractResultJSONData);
        });
        
      console.log("test",JSON.stringify(
        [
          {
          "key1":"value1",
          "key2":"value2"
          },
          {
          "key3":"value3",
          "key4":"value4"
          }
        ]
      ))
    },
    // onComplete(data){
    //   console.log('data:', data);
    //   if(data.type == "USER_DENIED_ACCOUNT_AUTHORIZATION"){
    //     this.$toast.add({severity:'error', summary: 'User Denied Account Authorization', group: 'br', life: 3000});
    //   }
    //   else if(data.type == "MAINNET"){
    //     console.log("this_mainNet",this.$refs);
    //     var metaMaskAddress = data.metaMaskAddress;
    //     for(var i=0;i<loginData.length;i++){
    //       if(loginData[i].userId.includes(metaMaskAddress)){
    //         this.actualuserType = loginData[i].type;
    //         this.actualmetaMaskAddress = metaMaskAddress;
    //         this.hitContract();
    //         this.$toast.add({severity:'success', summary: 'Successfully Logged in', group: 'br', life: 3000});
    //       }
    //       else{
    //         this.$toast.add({severity:'info', summary: 'New User, Kindly Register', group: 'br', life: 3000});
    //       }
    //     }
    //   }
    //   else if(data.type == "NO_INSTALL_METAMASK"){
    //     this.$toast.add({severity:'error', summary: 'Metamask is not installed', group: 'br', life: 3000});
    //   }
    //   else if(data.type == "NO_LOGIN"){
    //     this.$toast.add({severity:'error', summary: 'Not Logged in', group: 'br', life: 3000});
    //   }
    //   else if(data.type == "NETWORK_ERROR"){
    //     this.$toast.add({severity:'error', summary: 'Network Error', group: 'br', life: 3000});
    //   }
    //   else{
    //     this.$toast.add({severity:'error', summary: 'Login Error', group: 'br', life: 3000});
    //   }
    // },
    // connect() {
    //   console.log("this",this.$refs);
    //   this.check = true;
    //   this.$refs.metamask.init();
    // }
  }
}
</script>

<style lang="scss" scoped>
::v-deep(.p-password input) {
    width: 15rem
}
</style>