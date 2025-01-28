export default () => ({
  jwt: {
    access_secret: process.env.JWT_ACCESS_SECRET,
    refresh_secret: process.env.JWT_REFRESH_SECRET,
    access_expired: process.env.JWT_ACCESS_EXPIRED,
    refresh_expired: process.env.JWT_REFRESH_EXPIRED,
  },
});
