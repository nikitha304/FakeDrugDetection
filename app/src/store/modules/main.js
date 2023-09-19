const state = {
    test:"SampleTest",
    contract: null,
    currentUserAddress: null,
    currentUserdefaultAccount: null,
    currentUserRole: null,
    mainTableData: null,
    tableReload: null,
    homeTabIndex: null,
}

const getters = {
    test: state => state.test,
    contract: state => state.contract,
    currentUserAddress: state => state.currentUserAddress,
    currentUserdefaultAccount: state => state.currentUserdefaultAccount,
    currentUserRole: state => state.currentUserRole,
    mainTableData: state => state.mainTableData,
    tableReload: state => state.tableReload,
    homeTabIndex: state => state.homeTabIndex,
}

const actions = {
    async getTest(){
        return state.test;
    },
    async setTest({ commit }, arg){
        commit('test', arg);
    }
}

const mutations = {
    test: (state, arg) => (state.test = arg),
    contract: (state, arg) => (state.contract = arg),
    currentUserAddress: (state, arg) => (state.currentUserAddress = arg),
    currentUserdefaultAccount: (state, arg) => (state.currentUserdefaultAccount = arg),
    currentUserRole: (state, arg) => (state.currentUserRole = arg),
    mainTableData: (state, arg) => (state.mainTableData = arg),
    tableReload: (state, arg) => (state.tableReload = arg),
    homeTabIndex: (state, arg) => (state.homeTabIndex = arg),
}

export default {
    state,
    getters,
    actions,
    mutations
}