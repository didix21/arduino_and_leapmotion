/// @file matleap.cpp
/// @brief leap motion controller interface
/// @author Jeff Perry <jeffsp@gmail.com>
/// @version 1.0
/// @date 2013-09-12

#include "matleap.h"

// Under Windows, a Leap::Controller must be allocated after the MEX
// startup code has completed.  Also, a Leap::Controller must be
// deleted in the function specified by mexAtExit after all global
// destructors are called.  If the Leap::Controller is not allocated
// and freed in this way, the MEX function will crash and cause MATLAB
// to hang or close abruptly.  Linux and OS/X don't have these
// constraints, and you can just create a global Leap::Controller
// instance.

// Global instance pointer
matleap::frame_grabber *fg = 0;

// Exit function
void matleap_exit ()
{
    delete fg;
    fg = 0;
}

/// @brief process interface arguments
///
/// @param nlhs matlab mex output interface
/// @param plhs[] matlab mex output interface
/// @param nrhs matlab mex input interface
/// @param prhs[] matlab mex input interface
///
/// @return command number
int get_command (int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    int command;
    // check inputs
    switch (nrhs)
    {
        case 1:
        command = *mxGetPr (prhs[0]);
        break;
        case 0:
        mexErrMsgTxt ("Not enough input arguments");
        default:
        mexErrMsgTxt ("Too many input arguments");
    }
    // check that inputs agree with command
    switch (command)
    {
        case -1:
        {
            // set debug command requires 0 outputs
            if (nlhs != 0)
                mexErrMsgTxt ("Wrong number of outputs specified");
        }
        break;
        case 0:
        {
            // get version command requires 1 outputs
            if (nlhs != 0 && nlhs != 1)
                mexErrMsgTxt ("Wrong number of outputs specified");
        }
        break;
        case 1:
        {
            // frame grab command only requires one input
            if (nrhs > 1)
                mexErrMsgTxt ("Too many inputs specified");
            // frame grab command requires exactly one output
            if (nlhs != 0 && nlhs != 1)
                mexErrMsgTxt ("Wrong number of outputs specified");
        }
        break;
        default:
        mexErrMsgTxt ("An unknown command was specified");
    }
    return command;
}

/// @brief helper function
///
/// @param v values to fill array with
///
/// @return created and filled array
mxArray *create_and_fill (const Leap::Vector &v)
{
    mxArray *p = mxCreateNumericMatrix (1, 3, mxDOUBLE_CLASS, mxREAL);
    *(mxGetPr (p) + 0) = v.x;
    *(mxGetPr (p) + 1) = v.y;
    *(mxGetPr (p) + 2) = v.z;
    return p;
}
/// @brief get a frame from the leap controller
///
/// @param nlhs matlab mex output interface
/// @param plhs[] matlab mex output interface
void get_frame (int nlhs, mxArray *plhs[])
{
    // get the frame
    const matleap::frame &f = fg->get_frame ();
    
    // create matlab frame struct
    const char *frame_field_names[] =
    {
        "id",
        "timestamp",
        "pointables"
    };
    int frame_fields = sizeof (frame_field_names) / sizeof (*frame_field_names);
    plhs[0] = mxCreateStructMatrix (1, 1, frame_fields, frame_field_names);
    // fill the frame struct
    mxSetFieldByNumber (plhs[0], 0, 0, mxCreateDoubleScalar (f.id));
    mxSetFieldByNumber (plhs[0], 0, 1, mxCreateDoubleScalar (f.timestamp));
   
    // create the pointables structs
    
    if (f.pointables.count () > 0)
    {
        const char *pointable_field_names[] =
        {
            "id",
            "position",
            "velocity",
            "direction",
            "is_extended",
            "is_finger",
            "is_tool",
            "is_valid",
            "length",
            "width",
            "touch_distance",
            "time_visible"
        };
        int pointable_fields = sizeof (pointable_field_names) / sizeof (*pointable_field_names);
        mxArray *p = mxCreateStructMatrix (1, f.pointables.count (), pointable_fields, pointable_field_names);
        mxSetFieldByNumber (plhs[0], 0, 2, p); 
        // fill the pointables structs
		
        
		
        for (size_t i = 0; i < f.pointables.count (); ++i)
        {
            // set the id
            mxSetFieldByNumber (p, i, 0, mxCreateDoubleScalar (f.pointables[i].id ()));
            // create and fill arrays for vectors
            mxArray *pos = create_and_fill (f.pointables[i].tipPosition ());
            mxArray *vel = create_and_fill (f.pointables[i].tipVelocity ());
            mxArray *dir = create_and_fill (f.pointables[i].direction ());
			
            // set them in the struct
            mxSetFieldByNumber (p, i, 1, pos);
            mxSetFieldByNumber (p, i, 2, vel);
            mxSetFieldByNumber (p, i, 3, dir);
            mxSetFieldByNumber (p, i, 4, mxCreateDoubleScalar (f.pointables[i].isExtended ()));
            mxSetFieldByNumber (p, i, 5, mxCreateDoubleScalar (f.pointables[i].isFinger ()));
            mxSetFieldByNumber (p, i, 6, mxCreateDoubleScalar (f.pointables[i].isTool ()));
            mxSetFieldByNumber (p, i, 7, mxCreateDoubleScalar (f.pointables[i].isValid ()));
            mxSetFieldByNumber (p, i, 8, mxCreateDoubleScalar (f.pointables[i].length ()));
            mxSetFieldByNumber (p, i, 9, mxCreateDoubleScalar (f.pointables[i].width ()));
            mxSetFieldByNumber (p, i, 10, mxCreateDoubleScalar (f.pointables[i].touchDistance ()));
            mxSetFieldByNumber (p, i, 11, mxCreateDoubleScalar (f.pointables[i].timeVisible ()));
            
            
        }
		
    }
	
}

void mexFunction (int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    if (!fg)
    {
        fg = new matleap::frame_grabber;
        if (fg == 0)
            mexErrMsgTxt ("Cannot allocate a frame grabber");
        mexAtExit (matleap_exit);
    }
    switch (get_command (nlhs, plhs, nrhs, prhs))
    {
        // turn on debug
        case -1:
        fg->set_debug (true);
        return;
        // get version
        case 0:
        plhs[0] = mxCreateNumericMatrix (1, 2, mxDOUBLE_CLASS, mxREAL);
        *(mxGetPr (plhs[0]) + 0) = MAJOR_REVISION;
        *(mxGetPr (plhs[0]) + 1) = MINOR_REVISION;
        return;
        // get frame
        case 1:
        get_frame (nlhs, plhs);
        return;
        default:
        // this is a logic error
        mexErrMsgTxt ("unknown error: please contact developer");
    }
}
