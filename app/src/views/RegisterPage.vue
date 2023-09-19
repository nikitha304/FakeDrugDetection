<template>
    <div style="padding: 10%;">
    <Card style="width: 25rem; text-align: center; margin: 0 auto;">
        <template #header>
            Register
        </template>
        <template #content>
            <Button label="Register as Manufacturer" class="p-button-raised p-button-rounded register_btn" @click="addNewUser('Manufacturer')"/>
            <Button label="Register as Distributor" class="p-button-raised p-button-rounded register_btn" @click="addNewUser('Distributor')"/>
            <Button label="Register as Retailer" class="p-button-raised p-button-rounded register_btn" @click="addNewUser('Retailer')"/>
        </template>
    </Card></div>
</template>

<script>
export default {
  methods:{
    addNewUser(role){
        this.$store.getters.contract.methods.addNewUser('{"metaMaskAddress":"'+this.$store.getters.currentUserAddress+'", "defaultAccount": "'+this.$store.getters.currentUserdefaultAccount+'", "Role": "'+role+'"}').send({from: this.$store.getters.currentUserdefaultAccount, gas:3000000})
        .then((result) => {
            console.log("result in addNewUser",result);
            if(result) this.$toast.add({severity:'success', summary: 'Successfully Registered', group: 'br', life: 3000});
            this.$router.push({ name: 'home' });
            this.$store.commit('currentUserRole',role);
        });
        // setTimeout(() => {  
        //     this.$store.getters.contract.methods.getRegisteredUsers().call()
        //   .then((result) => {
        //     this.registeredUsers = JSON.parse(result);
        //     console.log("registeredUsers in Register Page",this.registeredUsers);
        //   });
        //  }, 10000);
        // this.$store.getters.contract.methods.getRegisteredUsers().call()
        //   .then((result) => {
        //     this.registeredUsers = JSON.parse(result);
        //     console.log("registeredUsers in Register Page",this.registeredUsers);
        //   });
    }
  }
}
</script>

<style>
.p-card-header{
    background-color: #3F51B5;
    color: aliceblue;
    font-size: 2rem;
    padding: 10px;
    height: 4rem;
    border-top-left-radius: 15px;
    border-top-right-radius: 15px;
}
.p-card{
    border-radius: 5%;
    box-shadow: 0px 0px 40px #8a9bfa;
}
.register_btn{
    margin: 1rem;
    width: 240px !important;
}
</style>
