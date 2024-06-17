export interface TransferResponse {
    transferID: string | null;
    error: string | null;
    code?: string | null;
}

export default async function tryTransfer(sender: string, request: string, token: string): Promise<TransferResponse> {
    try {
        const url ='https://sandbox-api.readyremit.com/v1/transfers';

        const jsonRequest = JSON.parse(request);
        jsonRequest.senderId = sender;

        const response = await fetch(url, {
            method: "POST",
            headers: {
                "Content-Type": "application/json",
                "Authorization": `Bearer ${token}`
            },
            body: JSON.stringify(jsonRequest)
        });

        const jsonResponse = await response.json();

        let error: string | null = null;
        let transferID: string | null = null;
        let errorCode: string | null = null;

        if (Array.isArray(jsonResponse) && jsonResponse.length > 0) {
            error = jsonResponse[0].message;
            errorCode = jsonResponse[0].code;
        }

        if (jsonResponse.transferId !== undefined) {
            transferID = jsonResponse.transferId;
        } else if (jsonResponse["transferId"] !== undefined) {
            transferID = jsonResponse["transferId"];
        }

        return {
            transferID,
            error,
            code: errorCode
        };
    } catch (error: any) {
        console.error("ERROR:", error);
        return {
            transferID: null,
            error: error.message
        };
    }
}
