function   echoAdd_Canecellation
%Reading the sound file and display it for user 
audiolocation=input('Enter location of wav file you want to read\n ');
[audio,Fs]=audioread(audiolocation); 

%display original signal 
sound(audio,Fs);
%Ploting the Original Signal
subplot(5,1,1);
plot(audio);
title('Orignail Signal');
fprintf('Press Enter to contuine\n')
pause(); % to avoid sound overlapping 

%switch case to use the wanted type of echo 
while(1)
    M=input('Choose operation you want to do:\n 1-high strength echo\n 2-Medium Strength Echo\n 3-Small strength Echo\n ');
    im=zeros(length(audio),1);
    switch M
        case 1
            im(1)=5;
            im(1e4)=4.5;
            im(2.5e4)=4;
            im(5e4)=3.5;
            im(7.5e4)=3;
            im(10e4)=2.5;
            im(12.5e4)=2;
            im(15e4)=1.5;
            im(17.5e4)=1;
            im(20e4)=0.5;
            m='r';
            subplot(5,1,2);
            plot(im,'Color','m');
            title('Impluse train'); 
            %choosing place to store signal after adding echo case high echo
            filename_used_for_echo='C:\Users\barbi\echo-added-High.wav'; %choosing place to store signal after adding echo case high echo
        case 2
            im(1)=2.5;
            im(1e4)=2;
            im(5e4)=1.5;
            im(10e4)=1;
            im(15e4)=0.75;
            im(20e4)=0.5;
            m='y';
            subplot(5,1,2);
             plot(im,'Color','m');
            title('Impluse train');
            %choosing place to store signal after adding echo case medium echo
            filename_used_for_echo='C:\Users\barbi\echo-added-medium.wav';%choosing place to store signal after adding echo case medium echo
        case 3
            im(1)=1.5;
            im(1e4)=1;
            im(10e4)=0.75;
            im(20e4)=0.5;
            subplot(5,1,2);
            m='g';
            plot(im,'Color','m');
            title('Impluse train');
            %choosing place to store signal after adding echo case low echo
            filename_used_for_echo='C:\Users\barbi\echo-added-low.wav';
    end
    
%adding echo by convolution 
    res=conv(audio,im);
    %ploting the sound with echo 
    subplot(5,1,3);
    plot(res,'color',m);
    title('Orignail Signal with Echo');
    
    %save the sound with echo by using audiowrite then read it 
    audiowrite(filename_used_for_echo,res,Fs); % input of these function is file to store in it, signal and freq.samples
    [audio1,Fs1]=audioread(filename_used_for_echo);%read from the file and display the sound eith echo
    sound(audio1,Fs1);
    fprintf('Press Enter to contuine\n')
    pause();% to avoid sound overlapping 
    
%removing echo by Fourier Transform
    im=zeros(length(res),1); %by using padding by doubling size of impluse response to make it suitable for matrix division 
    switch M
        case 1
            im(1)=5;
            im(1e4)=4.5;
            im(2.5e4)=4;
            im(5e4)=3.5;
            im(7.5e4)=3;
            im(10e4)=2.5;
            im(12.5e4)=2;
            im(15e4)=1.5;
            im(17.5e4)=1;
            im(20e4)=0.5;
            subplot(5,1,4);
            plot(im,'Color','m');
            title('Impluse train to make suitable for fourier transform');
            %choosing place to store signal after removing echo when echo is high
            filename_used_after_cal='C:\Users\barbi\echo-removed-High.wav';
        case 2
            im(1)=2.5;
            im(1e4)=2;
            im(5e4)=1.5;
            im(10e4)=1;
            im(15e4)=0.75;
            im(20e4)=0.5;
            subplot(5,1,4);
            plot(im,'Color','m');
            title('Impluse train to make suitable for fourier transform');
            %choosing place to store signal after removing echo when echo is medium
            filename_used_after_cal='C:\Users\barbi\echo-removed-medium.wav';
        case 3
            im(1)=1.5;
            im(1e4)=1;
            im(10e4)=0.75;
            im(20e4)=0.5;
            subplot(5,1,4);
            plot(im,'Color','m');
            title('Impluse train to make suitable for fourier transform');
            %choosing place to store signal after removing echo when echo low
            filename_used_after_cal='C:\Users\barbi\echo-removed-low.wav';
    end
    
 %get fourier transform 
    h_f=fft(im); %DTFT for impluse train after zero padding 
    y_f=fft(res); %DTFT for signal with echo
    x_f=ifft(y_f./h_f); %getting original signal in freq.domain 
    x_f=x_f(1:length(audio),1);% convert it to row to plot it 
    subplot(5,1,5);
    plot(x_f);%plot original signal
    title('Orignail Signal after Echo cancellation');
 %Storing the signal after cancellation in file then read it 
    audiowrite(filename_used_after_cal,x_f,Fs);
    [audio2,Fs2]=audioread(filename_used_after_cal);
    sound(audio2,Fs2);% display the original signal obtained by echo canecllation 

    
    x=input('Want to do another operation?\n 1-Yes\n 2-No\n');
    if x~=1
        break;
    end
 end 
 

end

