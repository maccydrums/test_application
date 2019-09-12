<template>
  <transition name="modal-fade">
    <div class="modal-backdrop">
      <div class="modal">
        <div class="modal-header">
          <slot name="header">
            <label for="input1">Car brand</label>
            <input id="input1" v-model="name" type="text" placeholder="Car brand" required />
          </slot>
        </div>
        <div class="modal-header">
          <slot name="header">
            <label for="input2">Model</label>
            <input id="input2" v-model="description" type="text" placeholder="Model" required />
          </slot>
        </div>
        <div class="modal-header">
          <slot name="header">
            <label for="input3">Favorite</label>
            <input id="input3" v-model="favorite" type="checkbox" placeholder="Favorite" required />
          </slot>
        </div>
        <div class="modal-footer">
          <slot name="footer">
            <button type="button" class="btn-green" @click="addCar">Add car!</button>
            <button type="button" class="btn-red" @click="close">Close!</button>
          </slot>
        </div>
      </div>
    </div>
  </transition>
</template>

<script>
import Axios from 'axios';
export default {
  name: 'Modal',
  data: () => {
    return {
      name: '',
      description: '',
      favorite: false
    };
  },
  methods: {
    close() {
      this.$emit("close");
    },
    addCar() {
      const meta = document.querySelector('meta[name="csrf-token"]');
      Axios.post(
        "/cars",
        {
          name: this.name,
          description: this.description,
          favorite: this.favorite
        },
        {
          method: "POST",
          headers: {
            "content-type": "application/json",
            "X-CSRF-Token": meta.content,
            "X-Requested-With": "XMLHttpRequest"
          }
        }
      ).then(() => {
        // this.testGet();
      });
    }
  }
};
</script>