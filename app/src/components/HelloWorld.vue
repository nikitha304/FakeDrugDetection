
<template>
  <div class="p-fluid">
      <div class="card">
          <h5>Basic</h5>
          <Chips v-model="value1" />

          <h5>Comma Separator</h5>
          <Chips v-model="value2" separator="," />

          <h5>Template</h5>
          <Chips v-model="value3">
              <template #chip="slotProps">
                  <div>
                      <span>{{slotProps.value}} - (active) </span>
                      <i class="pi pi-user-plus" style="font-size: 14px"></i>
                  </div>
              </template>
          </Chips>
      </div>
  </div>
</template>

<script>
export default {
  data() {
      return {
          value1: null,
          value2: null,
          value3: null
      }
  }
}
</script>