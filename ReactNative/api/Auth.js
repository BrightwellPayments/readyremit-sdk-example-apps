
export default async function onAuth(senderId, clientSecret, clientId) {
    let url = "https://sandbox-api.readyremit.com/v1/oauth/token";
    try {
        const response = await fetch(url, {
            method: "POST",
            headers: {
                "Content-Type": "application/json"
            },
            body: JSON.stringify({
                grant_type: "client_credentials",
                sender_id: senderId,
                audience: "https://sandbox-api.readyremit.com",
                client_id: clientId,
                client_secret: clientSecret
            })
        });
        const json = await response.json();
        console.log(json)
        var error = null;
        var token = null;
        if (json[0] !== null && json[0] !== undefined) {
            error = json[0].description;
        }
        if (json.access_token !== null) {
            token = json.access_token;
        }
        return {
            "token": token,
            "error": error
        }
    } catch (error) {
        return {
            "token": "",
            "error": error
        }
    }
}