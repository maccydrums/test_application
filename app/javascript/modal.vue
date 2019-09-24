<template>
  <transition name="modal-fade">
    <div class="modal-backdrop">
      <div class="modal">
        <div class="modal-header" :class="{error: validation.hasError('name')}">
          <slot name="header">
            <label for="input1">{{ t.table.titles.brand }}</label>
            <input
              id="input1"
              v-bind:class="{ 'is-invalid': validation.hasError('name')}"
              v-model="name"
              type="text"
              :placeholder="t.description.brand"
              required
            />
            <div class="text-errors">{{ validation.firstError('name') }}</div>
            <!-- <div class="text-errors" v-if="errors.nameError">
              <p
                class="text-danger"
                :key="error"
                v-for="error in errors.nameError"
              >This input {{ error }}!</p>
            </div>-->
          </slot>
        </div>
        <div class="modal-header" :class="{error: validation.hasError('description')}">
          <slot name="header">
            <label for="input2">{{ t.table.titles.model }}</label>
            <input
              id="input2"
              v-bind:class="{ 'is-invalid': validation.hasError('description')}"
              v-model="description"
              type="text"
              :placeholder="t.description.model"
              required
            />
            <div class="text-errors">{{ validation.firstError('description') }}</div>
            <!-- <div class="text-errors" v-if="errors.descriptionError">
              <p
                class="text-danger"
                :key="error"
                v-for="error in errors.descriptionError"
              >This input {{ error }}!</p>
            </div>-->
          </slot>
        </div>
        <div class="modal-header">
          <slot name="header">
            <label for="input3">{{ t.buttons.upload }}</label>
            <input
              data-direct-upload-url="/rails/active_storage/direct_uploads"
              direct_upload="true"
              type="file"
              ref="inputFile"
              @change="uploadImage()"
            />
          </slot>
        </div>
        <div class="modal-header">
          <h3>{{ t.table.titles.favorite }}</h3>
          <slot name="header">
            <div class="modal-header-checkbox">
              <input type="checkbox" id="input3" v-model="favorite" required />
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
              :disabled="this.name === '' || this.description === ''"
              v-if="!this.sendCar"
              class="btn-green"
              @click="addCar"
            >{{ t.buttons.add }}</button>
            <button type="button" v-else class="btn-green" @click="editCar()">{{ t.buttons.save }}</button>
            <button type="button" class="btn-red" @click="close">{{ t.buttons.close }}</button>
          </slot>
        </div>
      </div>
    </div>
  </transition>
</template>

<script>
import Axios from "axios";
import { Validator } from "simple-vue-validator";
import { DirectUpload } from "@rails/activestorage";

export default {
  props: ["onEdit", "sendCar"],
  name: "Modal",
  data() {
    return {
      // params: {
      //   name: this.sendCar ? this.sendCar.name : "",
      //   description: this.sendCar ? this.sendCar.description : "",
      //   favorite: this.sendCar ? this.sendCar.favorite : false,
      //   id: this.sendCar ? this.sendCar.id : ""
      // },
      errors: {
        nameError: "",
        descriptionError: "",
        favoriteError: ""
      },
      name: this.sendCar ? this.sendCar.name : "",
      description: this.sendCar ? this.sendCar.description : "",
      favorite: this.sendCar ? this.sendCar.favorite : false,
      id: this.sendCar ? this.sendCar.id : "",
      t: window.I18n,
      uploadPicture: null,
      blob_id: "",
      filename: '',
      size: '',
      type: '',
    };
  },
  validators: {
    name(value) {
      return Validator;
    },
    description(value) {
      return Validator.value(value).required();
    }
  },
  methods: {
    uploadImage() {
      this.uploadPicture = this.$refs.inputFile.files[0];
      const input = document.querySelector("input[type=file]");

      const url = input.dataset.directUploadUrl;
      const upload = new DirectUpload(this.uploadPicture, url);

      upload.create((error, blob) => {
        if (error) {
          console.log(error);
        } else {
          this.blob_id = blob.signed_id;
          console.log("from blob variabel", this.blob_id);
          console.log("this.uploaadpicture", this.uploadPicture);

          // const meta = document.querySelector('meta[name="csrf-token"]');
          // Axios.post(
          //   "/rails/active_storage/disk/:encoded_token/" + this.blob_id,
          //   {
          //     filename: this.uploadPicture.name,
          //     size: this.uploadPicture.size,
          //     type: this.uploadPicture.type
          //   },
          //   {
          //     method: "POST",
          //     headers: {
          //       "content-type": "application/json",
          //       "X-CSRF-Token": meta.content,
          //       "X-Requested-With": "XMLHttpRequest"
          //     }
          //   }
          // )
          //   .then(res => {
          //     console.log(res.data);
          //   })
          //   .catch(err => {
          //     console.log(err);
          //   });
        }
      });
    },
    close() {
      this.$emit("close");
    },
    addCar() {
      this.$validate();
      const meta = document.querySelector('meta[name="csrf-token"]');
      Axios.post(
        "/cars",
        {
          name: this.name,
          description: this.description,
          favorite: this.favorite,
          image_url: this.blob_id
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
          this.newId = res.data.id;
          console.log("IMAGE NAME", this.uploadPicture);
          console.log(res.data);
          this.imagePut();
        })
        .catch(err => {
          // this.errors.nameError = err.response.data.name;
          // this.errors.descriptionError = err.response.data.description;
          // this.errors.favoriteError = err.response.data.favorite;
          // console.log("Error", err.response.data);
        });

      Axios.post(
        "/rails/active_storage/disk/" + this.blob_id,
        {
          filename: this.uploadPicture.name,
          size: this.uploadPicture.size,
          type: this.uploadPicture.type
        },
        {
          method: "POST",
          headers: {
            "content-type": "multipart/form-data",
            "X-CSRF-Token": meta.content,
            "X-Requested-With": "XMLHttpRequest"
          }
        }
      )
        .then(res => {
          console.log(res.data);
        })
        .catch(err => {
          console.log(err);
        });
    },
    editCar() {
      const meta = document.querySelector('meta[name="csrf-token"]');
      Axios.put(
        "/cars/" + this.id,
        {
          name: this.name,
          description: this.description,
          favorite: this.favorite,
          image_url: this.uploadPicture
        },
        {
          method: "PUT",
          headers: {
            "content-type": "application/json",
            "X-CSRF-Token": meta.content,
            "X-Requested-With": "XMLHttpRequest"
          }
        }
      )
        .then(res => {
          this.close();
          this.$emit("updateOnPut", res.data);
        })
        .catch(err => {
          console.log(err);
        });
    }
  }
};
</script>