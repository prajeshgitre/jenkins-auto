/*
 * Copyright 2023 Niveus Solutions Pvt. Ltd.
 *
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

# Module to create cloud storage
module "cloud_storage" {

  source     = "../../modules/terraform-google-storage/"
  for_each   = { for bucket in var.cloud_storage : bucket.name => bucket }
  name       = each.value.name
  versioning = each.value.versioning
  project_id = each.value.project_id
  location   = each.value.location
  labels     = each.value.labels
  public_access_prevention = each.value.public_access_prevention
  
}