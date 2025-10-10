import { createBrowserRouter } from "react-router-dom";
import Auth from "../pages/authentication/auth";
import Layout from "../components/layout";
import DashBoard from "../pages/admin/dashboard/dashboard";
import HomePage from "../pages/accountant/homePage/homePage";

const router = createBrowserRouter([
  {
    path: "/authencation",
    element: <Auth />,
  },
  {
    path: "/admin",
    element: <Layout />,
    children: [{ index: true, element: <DashBoard /> }],
  },
  {
    path: "/accountant",
    element: <Layout />,
    children: [{ index: true, element: <HomePage /> }],
  },
]);
export default router;
