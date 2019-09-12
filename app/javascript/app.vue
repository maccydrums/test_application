<template>
  <div id="app">
    <h1>{{message}}</h1>
    <div class="add-btn">
      <button type="button" class="btn" @click="showModal">Add a new car!</button>
      <modal v-show="isModalVisible" @close="closeModal" />
    </div>

    <table>
      <tr>
        <th>Car brands</th>
        <th>Models</th>
        <th>Favorite</th>
        <th></th>
      </tr>
      <tr v-for="car in cars" :key="car.id">
        <td>{{ car.name }}</td>
        <td>{{ car.description}}</td>
        <td>{{ car.favorite }}</td>
        <td class="td-btn">
          <button v-on:click="onDelete(car)">Delete</button>
        </td>
      </tr>
    </table>
  </div>
</template>

<script>
import Axios from "axios";
import Modal from "./modal";
export default {
  components: {
    Modal
  },
  mounted() {
    // const meta = document.querySelector('meta[name="csrf-token"]');
    // console.log(meta.content);
    //.getAttribute('content'))
    this.testGet();
  },
  data: function() {
    return {
      message: "Car application!",
      cars: {},
      isModalVisible: false
    };
  },
  methods: {
    testGet() {
      const meta = document.querySelector('meta[name="csrf-token"]');
      const url = "/cars";
      Axios.get(url, {
        headers: {
          // "X-Requested-With": "XMLHttpRequest",
          "X-CSRF-Token": meta.content,
          Accept: "application/json"
        }
      }).then(response => {
        this.cars = response.data;
      });
    },
    async onDelete(car) {
      const meta = document.querySelector('meta[name="csrf-token"]');
      try {
        Axios.delete("/cars/" + car.id, {
          method: "DELETE",
          headers: {
            "content-type": "application/json",
            "X-CSRF-Token": meta.content,
            "X-Requested-With": "XMLHttpRequest"
          }
        }).then(() => {
          this.testGet();
        });
      } catch (error) {
        console.log(error);
      }
    },
    closeModal() {
      this.isModalVisible = false;
    },
    showModal() {
      this.isModalVisible = true;
    }
  }
};
</script>

<style scoped>
</style>