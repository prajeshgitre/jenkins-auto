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

module "service_accounts" {
  source        = "../../modules/terraform-google-service-account/"
  for_each      = { for account in var.service_accounts_list : account.display_name => account }
  project_id    = each.value.project_id
  prefix        = each.value.prefix
  display_name  = each.value.display_name
  names         = each.value.names
  project_roles = each.value.project_roles

}
