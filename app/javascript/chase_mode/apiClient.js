import axios from 'axios'

const host = process.env.ASSET_HOST
const element = document.querySelector("#chase_mode_root")

const getHeaders = () => {
  if (element) {
    return {
      'access-token': element.dataset.accessToken,
      'client': element.dataset.client,
      'uid': element.dataset.uid,
    }
  } else {
    return {}
  }
}

const client = axios.create({
  baseURL: host,
  headers: getHeaders()
});

export { host }

export default client
