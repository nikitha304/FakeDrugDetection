<template>
    <DataTable v-bind:value="$store.getters.mainTableData" ref="dt" class="p-datatable-sm custom_table"
    :resizableColumns="ToggleView" showGridlines stripedRows removableSort columnResizeMode="expand" 
    :reorderableColumns="true" :loading="loading"
    responsiveLayout="scroll" scrollHeight="500px" scrollDirection="both"
    v-model:filters="filters1" filterDisplay="row" :globalFilterFields="globalFilters"
    :paginator="true" :rows="10"
    paginatorTemplate="CurrentPageReport FirstPageLink PrevPageLink PageLinks NextPageLink LastPageLink RowsPerPageDropdown"
    :rowsPerPageOptions="[10,20,50]"
    currentPageReportTemplate="Showing {first} to {last} of {totalRecords}">
        <template #header>
            <div class="flex justify-content-between flex-wrap">
                <div class="flex align-items-center justify-content-center">
                    <Button v-if="$store.getters.homeTabIndex == 0 && ($store.getters.currentUserRole == 'Distributor' || $store.getters.currentUserRole == 'Retailer')" label="Add Purchase Order" class="p-button-raised table_btn" @click="openaddNewPO()"/>
                    <Button v-if="$store.getters.homeTabIndex == 1 && $store.getters.currentUserRole == 'Manufacturer'" label="Add New Drug" class="p-button-raised table_btn" @click="openaddDrugModal()"/>
                </div>
                <div class="flex align-items-center justify-content-center">
                    <MultiSelect class="p-mr-2" :modelValue="selectedColumns" :options="Columns" optionLabel="Title" @update:modelValue="onToggle"
                      placeholder="Select Columns" style="width: 20em"/>
                    <span class="p-input-icon-left" style="margin-left:10px;">
                      <i class="pi pi-search" />  
                      <InputText v-model="filters1['global'].value" placeholder="Global Search" v-tooltip.top="'Type anything to search'"/>
                    </span>
                </div>
            </div>
        </template>
        <template #empty>
            <span>No Records found.</span>
        </template>
        <Column v-for="(col, index) of selectedColumns" :filterField="col.Key" :showFilterMenu="false" :field="col.Key" :header="col.Title" :footer="col.Title" :key="col.Key + '_' + index">
            <template #body="slotProps">
                <div v-if="col.Title == 'Status'">
                    <ToggleButton @change="changeStatus(slotProps.data)" v-model="slotProps.data[col.Key]" onLabel="Approved" offLabel="Pending" onIcon="pi pi-check" offIcon="pi pi-times" class="w-full sm:w-10rem" :disabled="$store.getters.currentUserAddress != slotProps.data['Seller'] || slotProps.data[col.Key]"/>
                </div>
                <div v-else-if="col.Title == 'Quantity'">
                    <Button v-if="$store.getters.homeTabIndex == 1 && $store.getters.currentUserRole == 'Manufacturer'" icon="pi pi-pencil" class="p-button-raised p-button-sm" @click="editQuantity(slotProps.data)" style="width:1rem;height:1.75rem;" :disabled="$store.getters.currentUserAddress != slotProps.data['Owner']"/>
                    {{slotProps.data[col.Key]}}
                </div>
                <div v-else>
                    {{slotProps.data[col.Key]}}
                </div>
            </template>
            <template #filter>
                <InputText type="text" v-model="filters1[col.Key].value" class="p-column-filter" v-bind:placeholder="'Search by '+ col.Title" v-tooltip.top="'Type anything to search'"/>
            </template>
        </Column>
    </DataTable>
    <Dialog header="Add New Purchase Order" v-model:visible="addPODisplay" :style="{width: '25vw'}" :modal="true">
        <div class="p-inputgroup addDrugField">
          <span class="p-inputgroup-addon">
            <i class="pi pi-user"></i>
          </span>
          <span class="p-float-label">
            <InputText id="BuyerID" type="text" v-model="$store.getters.currentUserAddress" readonly />
            <label for="BuyerID">Buyer ID</label>
          </span>
        </div>
        <span class="p-float-label addDrugField">
            <InputText id="addPOID" type="text" v-model="addPOID" style="width:345px !important;" readonly/>
            <label for="addPOID">Purchase Order</label>
        </span>
        <span class="p-float-label addDrugField">
            <Dropdown v-model="addPOSeller" v-on:hide="onSellerChange()" :options="registeredSellers" optionLabel="metaMaskAddress" optionValue="metaMaskAddress" placeholder="Select the Seller" style="width:345px !important;"/>
            <label for="SellerID">Seller ID</label>
        </span>
        <template v-for="(data,index) in addPODrugs" :key="index">
            <span class="p-float-label addDrugField">
                <Dropdown v-model="data.DrugID" :options="filteredDrugs" optionLabel="DrugID" optionValue="DrugID" placeholder="Select the Drug" style="width:345px !important;"/>
                <label for="DrugID">Drug ID-{{index}}</label>
            </span>
            <span class="p-float-label addDrugField">
                <InputNumber inputId="Quantity" v-model="data.Quantity" showButtons style="width:345px !important;"/>
                <label for="Quantity">Quantity-{{index}}</label>
            </span>
        </template>
        <template #footer>
            <Button label="Add Drug" class="p-button-raised table_btn" @click="addnewPODrug()"/>
            <Button label="Create PO" class="p-button-raised table_btn" @click="addNewPO()"/>
            <Button label="Cancel" class="p-button-raised table_btn" @click="addDrugDisplay = false;"/>
        </template>
    </Dialog>
    <Dialog header="Add New Drug" v-model:visible="addDrugDisplay" :style="{width: '25vw'}" :modal="true">
        <div class="p-inputgroup addDrugField">
          <span class="p-inputgroup-addon">
            <i class="pi pi-user"></i>
          </span>
          <span class="p-float-label">
            <InputText id="Owner" type="text" v-model="$store.getters.currentUserAddress" readonly />
            <label for="Owner">Owner</label>
          </span>
        </div>
        <span class="p-float-label addDrugField">
            <InputText id="DrugID" type="text" v-model="newDrugDrugID" style="width:345px !important;" readonly/>
            <label for="DrugID">Drug ID</label>
        </span>
        <span class="p-float-label addDrugField">
            <InputText id="DrugName" type="text" v-model="newDrugDrugName" style="width:345px !important;"/>
            <label for="DrugName">Drug Name</label>
        </span>
        <span class="p-float-label addDrugField">
            <InputNumber inputId="Quantity" v-model="newDrugQuantity" showButtons style="width:345px !important;"/>
            <label for="Quantity">Quantity</label>
        </span>
        <template #footer>
            <Button label="Add" class="p-button-raised table_btn" @click="addNewDrug()"/>
            <Button label="Cancel" class="p-button-raised table_btn" @click="addDrugDisplay = false;"/>
        </template>
    </Dialog>
    <Dialog header="Update Quantity" v-model:visible="updateQuantityDisplay" :style="{width: '25vw'}" :modal="true">
        <div class="p-inputgroup addDrugField">
          <span class="p-inputgroup-addon">
            <i class="pi pi-user"></i>
          </span>
          <span class="p-float-label">
            <InputText id="Owner" type="text" v-model="modifiedQuantityRef.Owner" readonly />
            <label for="Owner">Owner</label>
          </span>
        </div>
        <span class="p-float-label addDrugField">
            <InputText id="DrugID" type="text" v-model="modifiedQuantityRef.DrugID" style="width:345px !important;" readonly/>
            <label for="DrugID">Drug ID</label>
        </span>
        <span class="p-float-label addDrugField">
            <InputText id="DrugName" type="text" v-model="modifiedQuantityRef.DrugName" style="width:345px !important;" readonly/>
            <label for="DrugName">Drug Name</label>
        </span>
        <span class="p-float-label addDrugField">
            <InputNumber inputId="Quantity" v-model="modifiedQuantityRef.Quantity" showButtons style="width:345px !important;"/>
            <label for="Quantity">Quantity</label>
        </span>
        <template #footer>
            <Button label="Update" class="p-button-raised table_btn" @click="updateQuantity()"/>
            <Button label="Cancel" class="p-button-raised table_btn" @click="updateQuantityDisplay = false;"/>
        </template>
    </Dialog>
</template>

<script>
import {FilterMatchMode} from 'primevue/api';

export default {
    name: 'BaseTable',
    data() {
      return {
        ToggleView: true,
        loading:false,
        selectedColumns: null,
        filters1: null,
        globalFilters:[],
        TableData: null,
        addDrugDisplay: false,
        newDrugDrugID: null,
        newDrugDrugName: null,
        newDrugQuantity: 100,
        addPODisplay: false,
        addPOSeller: null,
        addPOID: null,
        addPODrugs: null,
        filteredDrugs: null,
        registeredSellers: null,
        modifiedQuantityRef: null,
        updateQuantityDisplay: false,
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
      }
    },
    methods: {
        editQuantity(arg){
            this.modifiedQuantityRef = arg;
            this.updateQuantityDisplay = true;
        },
        updateQuantity(){
            this.$store.getters.contract.methods.getMedicinesRepo().call()
            .then((result) => {
                console.log("result in addNewUser",result);
                var parsedResult = JSON.parse(result);
                for(var i=0;i<parsedResult.length;i++){
                    if(parsedResult[i].Owner == this.modifiedQuantityRef.Owner && parsedResult[i].DrugID == this.modifiedQuantityRef.DrugID){
                        parsedResult[i].Quantity = this.modifiedQuantityRef.Quantity;
                    }
                }
                this.$store.getters.contract.methods.clearMedicinesRepo().send({from: this.$store.getters.currentUserdefaultAccount, gas:3000000});
                var temp = JSON.stringify(parsedResult);
                this.$store.getters.contract.methods.addNewDrug(temp.slice(1,temp.length-1)).send({from: this.$store.getters.currentUserdefaultAccount, gas:3000000})
                .then((result) => {
                    console.log("result in addNewUser",result);
                    if(result) this.$toast.add({severity:'success', summary: 'Successfully Updated Quantity', group: 'br', life: 3000});
                    this.$store.getters.contract.methods.getMedicinesRepo().call()
                    .then((result) => {
                    var parsedResult = JSON.parse(result);
                    console.log("result in updateTableData",result, parsedResult);
                    this.$store.commit('mainTableData',parsedResult);
                    this.$store.commit('tableReload',this.$store.getters.tableReload + 1);
                    });
                    this.updateQuantityDisplay = false;
                });
            });
        },
        changeStatus(arg){
            console.log("arg in changeStatus", arg);
            this.$store.getters.contract.methods.getPORepo().call()
            .then((result) => {
                var parsedResult = JSON.parse(result);
                console.log("parsedResult in changeStatus", parsedResult);
                console.log("parsedResult in changeStatus", arg.PurchaseOrder);
                for(var i=0;i<parsedResult.length;i++){
                    console.log("parsedResult in changeStatus", parsedResult[i].PurchaseOrder);
                    if(parsedResult[i].PurchaseOrder == arg.PurchaseOrder) parsedResult[i].Status = arg.Status;
                }
                this.$store.getters.contract.methods.clearPORepo().send({from: this.$store.getters.currentUserdefaultAccount, gas:3000000});
                var temp = JSON.stringify(parsedResult);
                console.log("JSON.stringify(parsedResult).slice(1,parsedResult.length-1)",temp,temp.slice(1,temp.length-1));
                this.$store.getters.contract.methods.addNewPO(temp.slice(1,temp.length-1)).send({from: this.$store.getters.currentUserdefaultAccount, gas:3000000})
                .then(() => {
                    this.$store.getters.contract.methods.getPORepo().call()
                    .then((result) => {
                    var innerparsedResult = JSON.parse(result);
                    console.log("result in updateTableData",result, innerparsedResult);
                    this.$store.commit('mainTableData',innerparsedResult);
                    this.$store.commit('tableReload',this.$store.getters.tableReload + 1);
                        this.$store.getters.contract.methods.getMedicinesRepo().call()
                        .then((result) => {
                            console.log("result in addNewUser",result);
                            var parsedResult = JSON.parse(result);
                            var temp = parsedResult.length;
                            var tempList = []
                            for(var i=0;i<temp;i++){
                                for(var j=0;j<arg.DrugsOrdered.length;j++){
                                    if(parsedResult[i].DrugID == arg.DrugsOrdered[j].DrugID && parsedResult[i].Owner == arg.Seller){
                                        parsedResult[i].Quantity -= arg.DrugsOrdered[j].Quantity;
                                        tempList.push(
                                            {
                                                "DrugID":arg.DrugsOrdered[j].DrugID,
                                                "DrugName":parsedResult[i].DrugName,
                                                "Owner":arg.Buyer,
                                                "Quantity":arg.DrugsOrdered[j].Quantity
                                            },
                                        )
                                    }
                                }
                                if(parsedResult[i].Owner == arg.Buyer){
                                    var localList = [];
                                    for(var k=0;k<tempList.length;k++){
                                        if(tempList[k].DrugID == parsedResult[i].DrugID){
                                            parsedResult[i].Quantity += tempList[k].Quantity;
                                        }
                                        else{
                                            localList.push(tempList[k]);
                                        }
                                    }
                                    tempList = localList;
                                }
                            }
                            if(tempList.length > 0){
                                parsedResult = parsedResult.concat(tempList);
                            }
                            this.$store.getters.contract.methods.clearMedicinesRepo().send({from: this.$store.getters.currentUserdefaultAccount, gas:3000000});
                            temp = JSON.stringify(parsedResult);
                            // console.log("JSON.stringify(parsedResult).slice(1,parsedResult.length-1)",temp,temp.slice(1,temp.length-1));
                            this.$store.getters.contract.methods.addNewDrug(temp.slice(1,temp.length-1)).send({from: this.$store.getters.currentUserdefaultAccount, gas:3000000})
                            .then((result) => {
                                console.log("result in addNewUser",result);
                                if(result) this.$toast.add({severity:'success', summary: 'Successfully Updated Purchase Order', group: 'br', life: 3000});
                            });
                        });
                    });
                });
            });
        },
        pad(n, length) {
            var len = length - (''+n).length;
            return (len > 0 ? new Array(++len).join('0') : '') + n
        },
        onSellerChange(){
            this.$store.getters.contract.methods.getMedicinesRepo().call()
            .then((result) => {
                console.log("result in addNewUser",result);
                var parsedResult = JSON.parse(result);
                var filteredDrugs = [];
                for(var i=0;i<parsedResult.length;i++){
                    if(parsedResult[i].Owner == this.addPOSeller) filteredDrugs.push(parsedResult[i]);
                }
                this.filteredDrugs = filteredDrugs;
            });
        },
        openaddNewPO(){
            this.addPODrugs = [
                {
                    "DrugID":null,
                    "Quantity":10
                }
            ];
            this.$store.getters.contract.methods.getPORepo().call()
            .then((result) => {
                var parsedResult = JSON.parse(result);
                this.addPOID = this.pad(parsedResult.length+1, 3);
            });
            this.$store.getters.contract.methods.getRegisteredUsers().call()
            .then((result) => {
                var parsedResult = JSON.parse(result);
                var registeredSellers = [];
                for(var i=0;i<parsedResult.length;i++){
                    if(this.$store.getters.currentUserRole=="Distributor" && parsedResult[i].Role == "Manufacturer") registeredSellers.push(parsedResult[i]);
                    if(this.$store.getters.currentUserRole=="Retailer" && parsedResult[i].Role == "Distributor") registeredSellers.push(parsedResult[i]);
                }
                console.log("registeredSellers in openaddNewPO",registeredSellers);
                this.registeredSellers = registeredSellers
            });
            this.addPODisplay=true;
        },
        openaddDrugModal(){
            this.$store.getters.contract.methods.getMedicinesRepo().call()
            .then((result) => {
                console.log("result in addNewUser",result);
                var parsedResult = JSON.parse(result);
                this.newDrugDrugID = this.pad(parsedResult.length+1, 3);
            });
            this.addDrugDisplay=true;
        },
        addnewPODrug(){
            console.log("before",this.addPODrugs);
            this.addPODrugs.push({"DrugID":null,"Quantity":10});
            console.log("after",this.addPODrugs);
        },
        addNewDrug(){
            this.$store.getters.contract.methods.addNewDrug('{"Owner":"'+this.$store.getters.currentUserAddress+'", "DrugID": "'+this.newDrugDrugID+'", "DrugName": "'+this.newDrugDrugName+'", "Quantity": "'+this.newDrugQuantity+'"}').send({from: this.$store.getters.currentUserdefaultAccount, gas:3000000})
            .then((result) => {
                console.log("result in addNewUser",result);
                if(result) this.$toast.add({severity:'success', summary: 'Successfully Added the Drug', group: 'br', life: 3000});
                this.$store.getters.contract.methods.getMedicinesRepo().call()
                .then((result) => {
                var parsedResult = JSON.parse(result);
                console.log("result in updateTableData",result, parsedResult);
                this.$store.commit('mainTableData',parsedResult);
                this.$store.commit('tableReload',this.$store.getters.tableReload + 1);
                });
            });
            this.addDrugDisplay=false;
        },
        addNewPO(){
            this.$store.getters.contract.methods.addNewPO('{"Buyer":"'+this.$store.getters.currentUserAddress+'", "Seller": "'+this.addPOSeller+'", "DrugsOrdered": '+JSON.stringify(this.addPODrugs)+', "PurchaseOrder": "'+this.addPOID+'", "Status": '+false+'}').send({from: this.$store.getters.currentUserdefaultAccount, gas:3000000})
            .then((result) => {
                console.log("result in addNewUser",result);
                if(result) this.$toast.add({severity:'success', summary: 'Successfully Created Purchase Order', group: 'br', life: 3000});
                this.$store.getters.contract.methods.getPORepo().call()
                .then((result) => {
                var parsedResult = JSON.parse(result);
                console.log("result in updateTableData",result, parsedResult);
                this.$store.commit('mainTableData',parsedResult);
                this.$store.commit('tableReload',this.$store.getters.tableReload + 1);
                });
            });
            this.addDrugDisplay=false;
        },
        onToggle(value) {
            this.selectedColumns = this.Columns.filter(col => value.includes(col));
        },
        clearFilter1() {
            this.initFilters1(this.Columns);
        },
        initFilters1(Columns) {
            var filter_inner = {};
            var globalFilters_inner = [];
            filter_inner['global'] = {value: null, matchMode: FilterMatchMode.CONTAINS};
            for(var i=0;i<Columns.length;i++){
            var field = Columns[i]['Key'];
            globalFilters_inner.push(field);
            filter_inner[field] = {value: null, matchMode: FilterMatchMode.CONTAINS};
            }
            this.filters1 = filter_inner;
            this.globalFilters = globalFilters_inner;
        },
        columnGenerator(arg){
            var Columns = [];
            if(arg.length == 0){
                if(this.$store.getters.homeTabIndex == 0){
                    Columns = [
                        {
                            "Title":"PurchaseOrder",
                            "Key":"PurchaseOrder"
                        },
                        {
                            "Title":"Buyer",
                            "Key":"Buyer"
                        },
                        {
                            "Title":"Seller",
                            "Key":"Seller"
                        },
                        {
                            "Title":"DrugsOrdered",
                            "Key":"DrugsOrdered"
                        },
                        {
                            "Title":"Status",
                            "Key":"Status"
                        },
                    ]
                }
                else{
                    Columns = [
                        {
                            "Title":"Owner",
                            "Key":"Owner"
                        },
                        {
                            "Title":"DrugID",
                            "Key":"DrugID"
                        },
                        {
                            "Title":"DrugName",
                            "Key":"DrugName"
                        },
                        {
                            "Title":"Quantity",
                            "Key":"Quantity"
                        },
                    ]
                }
            }
            else{
                for(var key in arg[0]){
                Columns.push({
                    "Title":key,
                    "Key":key
                })
                }
            }
            console.log("Columns",Columns);
            return Columns;
        }
    },
    created() {
        this.TableData = this.$store.getters.mainTableData;
        console.log("this.TableData in BaseTable",this.TableData);
        this.Columns = this.columnGenerator(this.TableData);
        this.selectedColumns = this.Columns;
        this.initFilters1(this.Columns);
    }
}
</script>

<style>
.table_btn{
    height: 40px;
}
input:read-only{
    background-color: #f8f8f8;
    cursor: not-allowed;
}
.addDrugField{
    margin-top: 10px;
}
</style>
