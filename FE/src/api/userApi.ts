import type { UserModel } from "../models/UserModel";

const BASE_URL = "http://localhost:8000";

export const getUserById = async (
  userId: string
): Promise<UserModel | null> => {
  try {
    const response = await fetch(`${BASE_URL}/users/${userId}`);
    if (!response.ok) {
      throw new Error(`HTTP error! status: ${response.status}`);
    }
    const data = await response.json();
    return data as UserModel;
  } catch (error) {
    console.error("❌ Error fetching user:", error);
    return null;
  }
};
