<template>
  <div id="app">
    <h1>{{ t.welcome }}</h1>

    <table>
      <tr>
        <th>{{ t.table.titles.brand }}</th>
        <th>{{ t.table.titles.model }}</th>
        <th>{{ t.table.titles.favorite }}</th>
        <th></th>
        <th></th>
        <th></th>
      </tr>
      <tr v-for="car in cars" :key="car.id">
        <td>{{ car.name }}</td>
        <td>{{ car.description}}</td>
        <td>{{ car.favorite }}</td>
        <td>
          <img :src="car.image_url" alt />
        </td>
        <td class="td-btn">
          <button type="button" class="btn" @click="toUpload">Upload image</button>
        </td>
        <td class="td-btn">
          <button type="button" class="btn" @click="getCar(car.id)">{{ t.buttons.edit }}</button>
        </td>
        <td class="td-btn">
          <button
            class="btn-red"
            v-on:click="onDelete(car)"
            @click="closeModal"
          >{{ t.buttons.delete }}</button>
        </td>
      </tr>
    </table>

    <div class="add-btn">
      <button type="button" class="btn" @click="showModal">{{ t.buttons.addNew }}</button>
      <modal
        :onEdit="{onEdit}"
        :sendCar="sendCar"
        v-if="isModalVisible"
        @close="closeModal"
        @refreshList="refreshList($event)"
        @updateOnPut="updateOnPut($event)"
      />
    </div>
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
    this.getList();
  },
  data() {
    return {
      message: "Car application!",
      cars: [],
      isModalVisible: false,
      onEdit: {},
      sendCar: null,
      t: window.I18n
    };
  },
  methods: {
    updateOnPut(updateCar) {
      const changedCar = this.cars.find(f => f.id === updateCar.id);

      (changedCar.name = updateCar.name),
        (changedCar.description = updateCar.description),
        (changedCar.favorite = updateCar.favorite);
      this.sendCar = null;
    },
    refreshList(newCar) {
      this.cars.push(newCar);
    },
    getList() {
      const meta = document.querySelector('meta[name="csrf-token"]');
      const url = "/cars";
      Axios.get(url, {
        headers: {
          "X-CSRF-Token": meta.content,
          Accept: "application/json"
        }
      }).then(response => {
        this.cars = response.data;
      });
    },
    onDelete(car) {
      const meta = document.querySelector('meta[name="csrf-token"]');
      Axios.delete("/cars/" + car.id, {
        method: "DELETE",
        headers: {
          "content-type": "application/json",
          "X-CSRF-Token": meta.content,
          "X-Requested-With": "XMLHttpRequest"
        }
      })
        .then(() => {
          this.getList();
        })
        .catch(error => {
          console.log(error);
        });
    },
    closeModal() {
      this.isModalVisible = false;
      this.sendCar = null;
    },
    showModal(car) {
      this.isModalVisible = true;
    },
    getCar(id) {
      this.sendCar = this.cars.find(x => x.id == id);
      this.isModalVisible = true;
    },
    toUpload() {
      // this.$route.push("/cars/upload_images");
      window.location.href = "/cars/upload_image"
    }
  }
};
</script>

<style scoped>
</style>