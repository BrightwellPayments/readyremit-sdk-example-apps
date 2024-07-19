export type AuthResponse = {
    token: string | null;
    error: string | null;
};

export default async function tryAuth(sender: string, clientSecret: string, clientID: string): Promise<AuthResponse> {
    const url = "https://sandbox-api.readyremit.com/v1/oauth/token";
    try {
        const response = await fetch(url, {
            method: "POST",
            headers: {
                "Content-Type": "application/json"
            },
            body: JSON.stringify({
                grant_type: "client_credentials",
                sender_id: sender,
                audience: "https://sandbox-api.readyremit.com",
                client_id: clientID,
                client_secret: clientSecret
            })
        });

        if (!response.ok) {
            throw new Error(`HTTP error! Status: ${response.status}`);
        }

        const json = await response.json();

        let error: string | null = null;
        let token: string | null = null;

        if (Array.isArray(json) && json.length > 0) {
            error = json[0]?.description ?? "Unknown error";
        }
        
        if (json.access_token) {
            token = json.access_token;
        }

        return {
            token,
            error
        };
    } catch (error: any) {
        console.error("Error during authentication:", error);
        return { token: null, error: error.message ?? "Unknown error" };
    }
}
