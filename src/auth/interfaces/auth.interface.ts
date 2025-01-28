interface LoginData {
  access_token: string; // Define the type of the access_token, for example, a string.
  refresh_token: string;
  isAdmin?:boolean
}

interface RegisterData {
  access_token: string;
  created_at: Date;
}

interface RefreshData {
  access_token: string;
}
