<template>
  <transition name="modal-fade">
    <div class="modal-backdrop">
      <!-- <div class="modal">
        <div class="modal-header">
          <slot name="header">
            <label for="input1">Car brand</label>
            <input
              id="input1"
              v-bind:class="{ 'is-invalid': errors.nameError}"
              v-model="params.name"
              type="text"
              placeholder="Car brand"
              required
            />
            <div class="text-errors" v-if="errors.nameError">
              <p
                class="text-danger"
                :key="error"
                v-for="error in errors.nameError"
              >This input {{ error }}!</p>
            </div>
          </slot>
        </div>
        <div class="modal-header">
          <slot name="header">
            <label for="input2">Model</label>
            <input
              id="input2"
              v-bind:class="{ 'is-invalid': errors.descriptionError }"
              v-model="params.description"
              type="text"
              placeholder="Model"
              required
            />
            <div class="text-errors" v-if="errors.descriptionError">
              <p
                class="text-danger"
                :key="error"
                v-for="error in errors.descriptionError"
              >This input {{ error }}!</p>
            </div>
          </slot>
        </div>
        <div class="modal-header">
          <h3>Favorite</h3>
          <slot name="header">
            <!-- <input
              id="input3"
              v-bind:class="{ 'is-invalid': errors.favoriteError }"
              v-model="params.favorite"
              type="checkbox"
              required
            />
            <div class="text-errors" v-if="errors.favoriteError">
              <p class="text-danger" :key="error" v-for="error in errors.favoriteError">{{ error }}</p>
            </div>
            <div class="modal-header-checkbox">
            <input
              type="checkbox"
              id="input3"
              v-bind:class="{ 'is-invalid': errors.favoriteError }"
              v-model="params.favorite"
              required
            />
            <div class="test">
              <label class="checkbox-label" for="input3"></label>
            </div>
            </div>
          </slot>
        </div>
        <div class="modal-footer">
          <slot name="footer">
            <button
              type="button"
              :disabled="params.name === ''"
              v-if="!this.sendCar"
              class="btn-green"
              @click="addCar"
            >Add car</button>
            <button type="button" v-else class="btn-green" @click="editCar">Save car</button>
            <button type="button" class="btn-red" @click="close">Close</button>
          </slot>
        </div>
      </div>-->

      <div class="modal">
        <div class="modal-header">
          <slot name="header">
            <label for="input1">Car brand</label>
            <input
              id="input1"
              v-bind:class="{ 'is-invalid': errors.nameError}"
              v-model="params.name"
              type="text"
              placeholder="Car brand"
              required
            />
            <div class="text-errors" v-if="errors.nameError">
              <p
                class="text-danger"
                :key="error"
                v-for="error in errors.nameError"
              >This input {{ error }}!</p>
            </div>
          </slot>
        </div>
        <div class="modal-header">
          <slot name="header">
            <label for="input2">Model</label>
            <input
              id="input2"
              v-bind:class="{ 'is-invalid': errors.descriptionError }"
              v-model="params.description"
              type="text"
              placeholder="Model"
              required
            />
            <div class="text-errors" v-if="errors.descriptionError">
              <p
                class="text-danger"
                :key="error"
                v-for="error in errors.descriptionError"
              >This input {{ error }}!</p>
            </div>
          </slot>
        </div>
        <div class="modal-header">
          <h3>Favorite</h3>
          <slot name="header">
            <!-- <input
              id="input3"
              v-bind:class="{ 'is-invalid': errors.favoriteError }"
              v-model="params.favorite"
              type="checkbox"
              required
            />
            <div class="text-errors" v-if="errors.favoriteError">
              <p class="text-danger" :key="error" v-for="error in errors.favoriteError">{{ error }}</p>
            </div>-->
            <div class="modal-header-checkbox">
              <input
                type="checkbox"
                id="input3"
                v-bind:class="{ 'is-invalid': errors.favoriteError }"
                v-model="params.favorite"
                required
              />
              <div class="test">
                <label class="checkbox-label" for="input3"></label>
              </div>
            </div>
          </slot>
        </div>
        <div class="modal-footer">
          <slot name="footer">
            <button
              type="button"
              :disabled="params.name === ''"
              v-if="!this.sendCar"
              class="btn-green"
              @click="addCar"
            >Add car</button>
            <button type="button" v-else class="btn-green" @click="editCar">Save car</button>
            <button type="button" class="btn-red" @click="close">Close</button>
          </slot>
        </div>
      </div>
    </div>
  </transition>
</template>

<script>
import Axios from "axios";
export default {
  props: ["onEdit", "sendCar"],
  name: "Modal",
  data() {
    return {
      params: {
        name: this.sendCar ? this.sendCar.name : "",
        description: this.sendCar ? this.sendCar.description : "",
        favorite: this.sendCar ? this.sendCar.favorite : false,
        id: this.sendCar ? this.sendCar.id : ""
      },
      errors: {
        nameError: "",
        descriptionError: "",
        favoriteError: ""
      },
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
          name: this.params.name,
          description: this.params.description,
          favorite: this.params.favorite
        },
        {
          method: "POST",
          headers: {
            "content-type": "application/json",
            "X-CSRF-Token": meta.content,
            "X-Requested-With": "XMLHttpRequest"
          }
        }
      )
        .then(res => {
          this.close();
          this.$emit("refreshList", res.data);
        })
        .catch(err => {
          this.errors.nameError = err.response.data.name;
          this.errors.descriptionError = err.response.data.description;
          this.errors.favoriteError = err.response.data.favorite;
          console.log("Error", err.response.data);
        });
    },
    editCar() {
      const meta = document.querySelector('meta[name="csrf-token"]');
      Axios.put(
        "/cars/" + this.params.id,
        {
          name: this.params.name,
          description: this.params.description,
          favorite: this.params.favorite
        },
        {
          method: "PUT",
          headers: {
            "content-type": "application/json",
            "X-CSRF-Token": meta.content,
            "X-Requested-With": "XMLHttpRequest"
          }
        }
      ).then(res => {
        this.close();
        this.$emit("updateOnPut", res.data);
      });
    }
  }
};
</script>