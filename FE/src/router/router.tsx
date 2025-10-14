import { createBrowserRouter } from "react-router-dom";
import Auth from "../pages/authentication/auth";
import Layout from "../components/layout";
import DashBoard from "../pages/admin/dashboard/dashboard";
import HomePage from "../pages/accountant/homePage/homePage";
import App from "../pages/app";
import Privacy from "../pages/Policy/Privacy";
import Contact from "../pages/Policy/Contact";
import FAQ from "../pages/Policy/FAQ";

const router = createBrowserRouter([
  {
    path: "/",
    element: <App />,
  },
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

  // ======================================= Policy
  {
    path: "/privacy",
    element: <Privacy />,
  },
  {
    path: "/contact",
    element: <Contact />,
  },
  {
    path: "/faq",
    element: <FAQ />,
  },
]);
export default router;
