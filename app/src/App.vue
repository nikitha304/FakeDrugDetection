<template>
  <!-- <div class="relative">
    <div class="absolute top-0 right-0 flex z-1000 text-sm">
      <SpeedDial :model="loginitems" direction="down" :transitionDelay="80" showIcon="pi pi-user" hideIcon="pi pi-times" buttonClass="p-button-outlined" />
    </div>
  </div>
  <TabMenu :model="items" /> -->
  <router-view/>
  <Toast position="bottom-right" group="br" />
</template>

<script>
import Web3 from 'web3'
import ABI from '../src/data/ABI.json'
export default {
  data() {
    console.log("this.$store.getters.test",this.$store.getters.test);
    this.$store.commit('test',"Changed Data");
    console.log("updated this.$store.getters.test",this.$store.getters.test);
    return {
      currentUserAddress: null,
      currentUserdefaultAccount: null,
      registeredUsers: null,
      // loginitems: [
      //   {
      //     label: 'Change User',
      //     icon: 'pi pi-user-edit',
      //     command: () => {
      //       this.$toast.add({ severity: 'info', summary: 'Add', detail: 'Data Added' });
      //     }
      //   },
      //   {
      //     label: 'Log Out',
      //     icon: 'pi pi-sign-out',
      //     command: () => {
      //       this.$toast.add({ severity: 'success', summary: 'Update', detail: 'Data Updated' });
      //     }
      //   },
      // ],
    }
  },
  created(){
    var localinstance = this;
    window.ethereum.on('accountsChanged', function () {
      localinstance.hitContract();
    })
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
        this.currentUserdefaultAccount = web3.eth.defaultAccount;
        console.log("currentUserdefaultAccount",this.currentUserdefaultAccount);
        let contractAddress = '0x6EE116AaBC9C67dc7d83fd5DF447b7f5ca60DFB3';
        
        let abi = ABI;
        let contract = new web3.eth.Contract(abi, contractAddress, web3.eth.defaultAccount);
        this.currentUserAddress = window.ethereum.selectedAddress;
        this.$store.commit('contract',contract);
        this.$store.commit('currentUserAddress',this.currentUserAddress);
        this.$store.commit('currentUserdefaultAccount',this.currentUserdefaultAccount);
        console.log("updated this.$store.getters.contract",this.$store.getters.contract);
        console.log("updated this.$store.getters.currentUserAddress",this.$store.getters.currentUserAddress);
        console.log("updated this.$store.getters.currentUserdefaultAccount",this.$store.getters.currentUserdefaultAccount);
        
        var role;
        // contract.methods.clearMedicinesRepo().send({from: this.$store.getters.currentUserdefaultAccount, gas:3000000});
        // contract.methods.clearPORepo().send({from: this.$store.getters.currentUserdefaultAccount, gas:3000000});
        contract.methods.getRegisteredUsers().call()
          .then((result) => {
            this.registeredUsers = JSON.parse(result);
            console.log("registeredUsers",this.registeredUsers);
            var numOfRegisteredUsers = this.registeredUsers.length;
            if(numOfRegisteredUsers != 0){
              var status = false;
              for(var i=0;i<numOfRegisteredUsers;i++){
                if(this.registeredUsers[i]["metaMaskAddress"] == this.currentUserAddress){
                  role = this.registeredUsers[i]["Role"];
                  status = true;
                }
              }
              if(!status){
                this.$router.push({ name: 'register' })
              }
              else{
                this.$router.push({ name: 'home' })
                this.$store.commit('currentUserRole',role);
                this.$toast.add({severity:'success', summary: 'Successfully Logged in', group: 'br', life: 3000});
              }
            }
            else{
              this.$router.push({ name: 'register' })
            }
          });
        })
    },
    addNewUser(contract){
      contract.methods.addNewUser({"metaMaskAddress":this.currentUserAddress, "defaultAccount": this.currentUserdefaultAccount, "Role": this.selectedRole}).call()
        .then((result) => {
          if(result) this.$toast.add({severity:'success', summary: 'Successfully Registered', group: 'br', life: 3000});
        });
    }
  }
}
</script>

<style>
#app {
  font-family: Avenir, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  color: #2c3e50;
}
</style>
