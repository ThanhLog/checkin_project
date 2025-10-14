import { BrowserRouter as Router, Routes, Route } from "react-router-dom";
import ServiceSelect from "./pages/ServiceSelect";
import HotelBooking from "./pages/HotelBooking";
import HospitalBooking from "./pages/HospitalBooking";

const AppRouter = () => (
  <Router>
    <Routes>
      <Route path="/" element={<ServiceSelect />} />
      <Route path="/checkin/hotel" element={<HotelBooking />} />
      <Route path="/checkin/hospital" element={<HospitalBooking />} />
    </Routes>
  </Router>
);

export default AppRouter;
