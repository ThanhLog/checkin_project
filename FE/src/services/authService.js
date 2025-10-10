import { auth, db } from "../store/firebase";
import {signInWithEmailAndPassword,
  createUserWithEmailAndPassword,
  updateProfile,
} from "firebase/auth";
import { doc, setDoc } from "firebase/firestore";

export const loginUser = async (email, password) => {
  try {
    const userCredential = await signInWithEmailAndPassword(
      auth,
      email,
      password
    );
    const user = userCredential.user;
    return { success: true, user };
  } catch (error) {
    console.error("❌ Lỗi đăng nhập:", error);
    return { success: false, error: error.message };
  }
};

export const registerUser = async (name, email, password, birthDate) => {
  try {
    console.log("Đang đăng ký với:", email, password);

    const userCredential = await createUserWithEmailAndPassword(
      auth,
      email,
      password
    );
    const user = userCredential.user;

    await updateProfile(user, { displayName: name });

    await setDoc(doc(db, "users", user.uid), {
      name,
      email,
      birthDate,
      createdAt: new Date(),
    });

    console.log("✅ Đăng ký thành công:", user.uid);
    return {
      success: true,
      user,
    };
  } catch (error) {
    console.error("❌ Lỗi đăng ký User:", error);
    return {
      success: false,
      error: error.message,
    };
  }
};
