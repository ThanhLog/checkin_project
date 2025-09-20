import { createBrowserRouter } from "react-router-dom";
import Auth from "../pages/authentication/auth";

const router = createBrowserRouter([
  {
    path: "/Authencation",
    element: <Auth />,
  },
  {
    path: "/Admin",
    
  }
]);
export default router;
