<template>
  <TabMenu :model="hometabs" @tab-change="updateTableData"/>
  <BaseTable v-if="check" :key="$store.getters.tableReload"/>
</template>

<script>
import BaseTable from '../views/BaseTable.vue';

export default {
  name: 'HomePage',
  components:{
    BaseTable
  },
  data() {
    return {
      hometabs: [
        {
          label: 'Purchase Order',
          icon: 'pi pi-bitcoin',
        },
        {
          label: 'Medicines',
          icon: 'pi pi-database',
        },
      ],
      check: false,
    }
  },
  methods: {
    updateTableData(event){
      console.log("event in updateTableData",event);
      if(event.index == 0){
        this.$store.getters.contract.methods.getPORepo().call()
        .then((result) => {
          this.$store.commit('homeTabIndex',0);
          var parsedResult = JSON.parse(result);
          console.log("result in updateTableData getPORepo",result, parsedResult);
          this.$store.commit('mainTableData',parsedResult);
          this.$store.commit('tableReload',this.$store.getters.tableReload + 1);
        });
      }
      else{
        this.$store.getters.contract.methods.getMedicinesRepo().call()
        .then((result) => {
          this.$store.commit('homeTabIndex',1);
          var parsedResult = JSON.parse(result);
          console.log("result in updateTableData",result, parsedResult);
          this.$store.commit('mainTableData',parsedResult);
          this.$store.commit('tableReload',this.$store.getters.tableReload + 1);
        });
      }
    },
  },
  created(){
    this.$store.getters.contract.methods.getPORepo().call()
    .then((result) => {
      this.$store.commit('homeTabIndex',0);
      console.log("result in created getPORepo",result);
      var parsedResult = JSON.parse(result);
      this.$store.commit('mainTableData',parsedResult);
      // this.$store.commit('tableReload',this.$store.getters.tableReload + 1);
      this.check = true;
    });
  }
}
</script>

<style>
html {
  font-size: 13px !important;
}
</style>
